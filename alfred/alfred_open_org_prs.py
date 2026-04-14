#!/usr/bin/env python3
"""Open all of the current user's PRs for a GitHub organization.

Designed for Alfred integration, but also usable from the command line.
"""

from __future__ import annotations

import argparse
import json
import os
import subprocess
import sys
import time
from pathlib import Path


CACHE_TTL_SECONDS = 600
MAX_ALFRED_ITEMS = 20
DEFAULT_SEARCH_LIMIT = 200
CACHE_PATH = Path.home() / "Library" / "Caches" / "alfred-open-org-prs" / "orgs.json"


class AlfredOpenOrgPRError(RuntimeError):
    """Raised for expected user-facing errors."""


def main() -> int:
    parser = build_parser()
    args = parser.parse_args()

    try:
        if args.command == "alfred":
            return run_alfred(args.query)
        if args.command == "open":
            return run_open(args.target, args.host, args.limit, args.dry_run)
        raise AlfredOpenOrgPRError(f"Unsupported command: {args.command}")
    except AlfredOpenOrgPRError as exc:
        if args.command == "alfred":
            print_alfred_items(
                [
                    {
                        "title": "GitHub PR opener unavailable",
                        "subtitle": str(exc),
                        "valid": False,
                    }
                ]
            )
            return 0

        print(str(exc), file=sys.stderr)
        return 1


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Open all of your PRs for a GitHub organization."
    )
    subparsers = parser.add_subparsers(dest="command", required=True)

    alfred_parser = subparsers.add_parser(
        "alfred", help="Emit Alfred Script Filter JSON."
    )
    alfred_parser.add_argument("query", nargs="?", default="")

    open_parser = subparsers.add_parser("open", help="Open matching PRs in the browser.")
    open_parser.add_argument("target", help="Organization or host/organization target.")
    open_parser.add_argument(
        "--host",
        help="GitHub host to use when target is only an organization name.",
    )
    open_parser.add_argument(
        "--limit",
        type=int,
        default=DEFAULT_SEARCH_LIMIT,
        help=f"Maximum number of PRs to fetch (default: {DEFAULT_SEARCH_LIMIT}).",
    )
    open_parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Print matching PR URLs instead of opening browser tabs.",
    )

    return parser


def run_alfred(query: str) -> int:
    candidates = get_all_org_candidates()
    normalized_query = query.strip().lower()

    if not candidates:
        raise AlfredOpenOrgPRError(
            "No authenticated GitHub hosts were found. Run `gh auth login` first."
        )

    if normalized_query:
        matches = [
            candidate
            for candidate in candidates
            if normalized_query in candidate["org"].lower()
            or normalized_query in candidate["target"].lower()
            or normalized_query in candidate["host"].lower()
        ]
    else:
        matches = candidates

    items = []
    for candidate in matches[:MAX_ALFRED_ITEMS]:
        items.append(
            {
                "uid": candidate["target"],
                "title": f"Open my PRs in {candidate['org']}",
                "subtitle": (
                    f"{candidate['host']} | Opens every open PR you authored in this org"
                ),
                "arg": candidate["target"],
                "autocomplete": candidate["target"],
                "valid": True,
            }
        )

    if not items:
        items.append(
            {
                "title": "No matching organizations",
                "subtitle": "Keep typing the org name or use host/org",
                "valid": False,
            }
        )

    print_alfred_items(items)
    return 0


def run_open(target: str, host: str | None, limit: int, dry_run: bool) -> int:
    resolved_host, org = resolve_target(target, host)
    prs = search_pull_requests(resolved_host, org, limit)

    if not prs:
        raise AlfredOpenOrgPRError(
            f"No open PRs found for {org} on {resolved_host} authored by the active gh account."
        )

    if dry_run:
        for pr in prs:
            print(pr["url"])
        return 0

    for pr in prs:
        subprocess.run(["open", pr["url"]], check=False)

    print(f"Opened {len(prs)} PR(s) for {org} on {resolved_host}.")
    return 0


def resolve_target(target: str, host: str | None) -> tuple[str, str]:
    target = target.strip()
    if not target:
        raise AlfredOpenOrgPRError("Missing organization. Pass `org` or `host/org`.")

    if host:
        return host.strip(), target

    if "/" in target:
        maybe_host, org = target.split("/", 1)
        if maybe_host and org:
            return maybe_host.strip(), org.strip()

    candidates = [
        candidate
        for candidate in get_all_org_candidates()
        if candidate["org"].lower() == target.lower()
    ]

    if len(candidates) == 1:
        return candidates[0]["host"], candidates[0]["org"]

    if len(candidates) > 1:
        options = ", ".join(candidate["target"] for candidate in candidates)
        raise AlfredOpenOrgPRError(
            f"Organization `{target}` exists on multiple hosts. Use one of: {options}"
        )

    raise AlfredOpenOrgPRError(
        f"Unknown organization `{target}`. Use Alfred lookup or pass host/org explicitly."
    )


def get_all_org_candidates() -> list[dict[str, str]]:
    cached = load_cached_orgs()
    if cached is not None:
        return cached

    candidates = []
    for host in get_authenticated_hosts():
        try:
            orgs = get_orgs_for_host(host)
        except AlfredOpenOrgPRError:
            continue

        for org in orgs:
            candidates.append({"host": host, "org": org, "target": f"{host}/{org}"})

    candidates.sort(key=lambda item: (item["org"].lower(), item["host"].lower()))
    write_cached_orgs(candidates)
    return candidates


def get_authenticated_hosts() -> list[str]:
    result = run_command(["gh", "auth", "status"], allow_failure=False)
    hosts = []
    for line in result.splitlines():
        if line and not line.startswith(" "):
            hosts.append(line.strip())

    if not hosts:
        raise AlfredOpenOrgPRError("No authenticated GitHub hosts found in `gh auth status`.")

    return hosts


def get_orgs_for_host(host: str) -> list[str]:
    payload = run_gh_json(["api", "user/orgs?per_page=100"], host=host)
    return [org["login"] for org in payload if org.get("login")]


def search_pull_requests(host: str, org: str, limit: int) -> list[dict[str, object]]:
    fields = "url,title,repository"
    return run_gh_json(
        [
            "search",
            "prs",
            "--owner",
            org,
            "--author",
            "@me",
            "--state",
            "open",
            "--archived=false",
            "--json",
            fields,
            "-L",
            str(limit),
        ],
        host=host,
    )


def run_gh_json(args: list[str], host: str | None = None) -> object:
    output = run_command(["gh", *args], host=host, allow_failure=False)
    try:
        return json.loads(output)
    except json.JSONDecodeError as exc:
        raise AlfredOpenOrgPRError(f"Failed to parse gh output: {exc}") from exc


def run_command(
    args: list[str], host: str | None = None, allow_failure: bool = False
) -> str:
    env = os.environ.copy()
    if host:
        env["GH_HOST"] = host

    result = subprocess.run(
        args,
        capture_output=True,
        text=True,
        env=env,
        check=False,
    )
    if result.returncode != 0 and not allow_failure:
        details = (result.stderr or result.stdout).strip() or "unknown gh failure"
        raise AlfredOpenOrgPRError(details)
    return result.stdout or result.stderr


def load_cached_orgs() -> list[dict[str, str]] | None:
    try:
        payload = json.loads(CACHE_PATH.read_text())
    except FileNotFoundError:
        return None
    except json.JSONDecodeError:
        return None

    generated_at = payload.get("generated_at", 0)
    if time.time() - generated_at > CACHE_TTL_SECONDS:
        return None

    orgs = payload.get("orgs")
    if not isinstance(orgs, list):
        return None

    return orgs


def write_cached_orgs(orgs: list[dict[str, str]]) -> None:
    CACHE_PATH.parent.mkdir(parents=True, exist_ok=True)
    CACHE_PATH.write_text(json.dumps({"generated_at": time.time(), "orgs": orgs}))


def print_alfred_items(items: list[dict[str, object]]) -> None:
    print(json.dumps({"items": items}))


if __name__ == "__main__":
    sys.exit(main())
