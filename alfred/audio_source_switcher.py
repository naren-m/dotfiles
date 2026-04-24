#!/usr/bin/env python3
"""List and switch macOS audio devices for Alfred."""

from __future__ import annotations

import argparse
import json
import subprocess
import sys
from pathlib import Path
from shutil import which


class AudioSourceSwitcherError(RuntimeError):
    """Raised for expected user-facing errors."""


def main() -> int:
    parser = build_parser()
    args = parser.parse_args()

    try:
        if args.command == "alfred":
            return run_alfred(args.query)
        if args.command == "switch":
            return run_switch(args.target, args.dry_run)
        raise AudioSourceSwitcherError(f"Unsupported command: {args.command}")
    except AudioSourceSwitcherError as exc:
        if args.command == "alfred":
            print(
                json.dumps(
                    {
                        "items": [
                            {
                                "title": "Audio switcher unavailable",
                                "subtitle": str(exc),
                                "valid": False,
                            }
                        ]
                    }
                )
            )
            return 0

        print(str(exc), file=sys.stderr)
        return 1


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="List and switch audio devices.")
    subparsers = parser.add_subparsers(dest="command", required=True)

    alfred_parser = subparsers.add_parser("alfred", help="Emit Alfred Script Filter JSON.")
    alfred_parser.add_argument("query", nargs="?", default="")

    switch_parser = subparsers.add_parser("switch", help="Switch to a selected device.")
    switch_parser.add_argument("target", help="JSON payload emitted by the Alfred item.")
    switch_parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Print the switch command instead of running it.",
    )

    return parser


def run_alfred(query: str) -> int:
    devices = build_items(query)
    print(json.dumps({"items": devices}))
    return 0


def build_items(query: str) -> list[dict[str, object]]:
    kind_filter, text_filter = normalize_query(query)
    current_devices = {
        "output": get_current_device("output"),
        "input": get_current_device("input"),
    }

    items: list[dict[str, object]] = []
    for kind in ("output", "input"):
        if kind_filter and kind_filter != kind:
            continue

        current_uid = current_devices[kind].get("uid")
        devices = get_devices(kind)
        devices.sort(key=lambda device: (device["uid"] != current_uid, device["name"].lower()))

        for device in devices:
            haystack = f"{kind} {device['name']} {device['uid']}".lower()
            if text_filter and text_filter not in haystack:
                continue

            current = device["uid"] == current_uid
            kind_label = "Output" if kind == "output" else "Input"
            title = f"{kind_label}: {device['name']}"
            if current:
                title += " (Current)"

            subtitle = (
                f"Switch {kind} device"
                if not current
                else f"Already current {kind} device"
            )

            items.append(
                {
                    "uid": f"{kind}:{device['uid']}",
                    "title": title,
                    "subtitle": subtitle,
                    "arg": json.dumps(
                        {"type": kind, "uid": device["uid"], "name": device["name"]},
                        separators=(",", ":"),
                    ),
                    "valid": True,
                }
            )

    if items:
        return items

    return [
        {
            "title": "No matching audio devices",
            "subtitle": "Try another filter or make sure devices are currently available",
            "valid": False,
        }
    ]


def normalize_query(query: str) -> tuple[str | None, str]:
    normalized = query.strip().lower()
    if not normalized:
        return None, ""

    prefixes = {
        "out ": "output",
        "output ": "output",
        "speaker ": "output",
        "speakers ": "output",
        "in ": "input",
        "input ": "input",
        "mic ": "input",
        "microphone ": "input",
    }
    for prefix, kind in prefixes.items():
        if normalized.startswith(prefix):
            return kind, normalized[len(prefix) :].strip()

    return None, normalized


def run_switch(target: str, dry_run: bool) -> int:
    try:
        payload = json.loads(target)
    except json.JSONDecodeError as exc:
        raise AudioSourceSwitcherError(f"Invalid switch target payload: {exc}") from exc

    device_type = payload.get("type")
    device_uid = payload.get("uid")
    device_name = payload.get("name", device_uid)
    if device_type not in {"input", "output"} or not isinstance(device_uid, str):
        raise AudioSourceSwitcherError("Switch target is missing a valid device type or uid.")

    binary = get_switch_audio_source_bin()
    command = [binary, "-t", device_type, "-u", device_uid]
    if dry_run:
        print(" ".join(command))
        return 0

    result = subprocess.run(command, capture_output=True, text=True, check=False)
    if result.returncode != 0:
        details = (result.stderr or result.stdout).strip() or "unknown switch failure"
        raise AudioSourceSwitcherError(details)

    print(f"Switched {device_type} to {device_name}.")
    return 0


def get_devices(device_type: str) -> list[dict[str, str]]:
    output = run_switch_audio_source(["-a", "-f", "json", "-t", device_type])
    devices = []
    for line in output.splitlines():
        line = line.strip()
        if not line:
            continue
        try:
            payload = json.loads(line)
        except json.JSONDecodeError as exc:
            raise AudioSourceSwitcherError(
                f"Unable to parse device list from SwitchAudioSource: {exc}"
            ) from exc
        devices.append(payload)
    return devices


def get_current_device(device_type: str) -> dict[str, str]:
    output = run_switch_audio_source(["-c", "-f", "json", "-t", device_type]).strip()
    if not output:
        raise AudioSourceSwitcherError(f"No current {device_type} device reported.")
    try:
        return json.loads(output)
    except json.JSONDecodeError as exc:
        raise AudioSourceSwitcherError(
            f"Unable to parse current {device_type} device from SwitchAudioSource: {exc}"
        ) from exc


def run_switch_audio_source(args: list[str]) -> str:
    binary = get_switch_audio_source_bin()
    result = subprocess.run(
        [binary, *args],
        capture_output=True,
        text=True,
        check=False,
    )
    if result.returncode != 0:
        details = (result.stderr or result.stdout).strip() or "unknown SwitchAudioSource failure"
        raise AudioSourceSwitcherError(details)
    return result.stdout


def get_switch_audio_source_bin() -> str:
    candidates = [
        which("SwitchAudioSource"),
        "/opt/homebrew/bin/SwitchAudioSource",
        "/usr/local/bin/SwitchAudioSource",
    ]
    for candidate in candidates:
        if candidate and Path(candidate).exists():
            return candidate

    raise AudioSourceSwitcherError(
        "SwitchAudioSource is not installed. Run `brew install switchaudio-osx`."
    )


if __name__ == "__main__":
    sys.exit(main())
