#!/usr/bin/env python3
"""List repositories with the current user's open PRs and open them on demand.

Designed for Alfred Script Filter + Run Script workflows, but also usable from
the command line.
"""

from __future__ import annotations

import argparse
import json
import os
import subprocess
import sys
import time
from pathlib import Path


ORG_CACHE_TTL_SECONDS = 600
PR_CACHE_TTL_SECONDS = 90
MAX_ALFRED_ITEMS = 40
DEFAULT_SEARCH_LIMIT = 200
CACHE_DIR = Path.home() / "Library" / "Caches" / "alfred-open-org-prs"
ORG_CACHE_PATH = CACHE_DIR / "orgs.json"
PR_CACHE_PATH = CACHE_DIR / "prs.json"
CONFIG_PATH = Path(__file__).with_suffix(".json")
TOKEN_CACHE: dict[tuple[str, str], str] = {}


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
        description="List repos that have your PRs, and open PRs for a selected repo."
    )
    subparsers = parser.add_subparsers(dest="command", required=True)

    alfred_parser = subparsers.add_parser(
        "alfred", help="Emit Alfred Script Filter JSON."
    )
    alfred_parser.add_argument("query", nargs="?", default="")

    open_parser = subparsers.add_parser("open", help="Open matching PRs in the browser.")
    open_parser.add_argument(
        "target",
        help="Repository target (`host/owner/repo`) or organization target (`alias` or `host/owner`).",
    )
    open_parser.add_argument(
        "--host",
        help="GitHub host to use when target omits the host.",
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
    repo_items = build_repo_items(query)
    if not repo_items:
        print_alfred_items(
            [
                {
                    "title": "No matching repositories",
                    "subtitle": "No open PRs matched your filter in the configured scopes",
                    "valid": False,
                }
            ]
        )
        return 0

    print_alfred_items(repo_items[:MAX_ALFRED_ITEMS])
    return 0


def build_repo_items(query: str) -> list[dict[str, object]]:
    prs = get_cached_or_fetch_prs()
    repo_map: dict[str, dict[str, object]] = {}

    for pr in prs:
        repo_target = pr["repo_target"]
        entry = repo_map.setdefault(
            repo_target,
            {
                "repo_target": repo_target,
                "repo_name": pr["repo_name"],
                "scope_target": pr["scope_target"],
                "urls": [],
                "titles": [],
            },
        )
        entry["urls"].append(pr["url"])
        entry["titles"].append(pr["title"])

    normalized_query = query.strip().lower()
    items: list[dict[str, object]] = []
    for entry in repo_map.values():
        haystack = " ".join(
            [
                str(entry["repo_name"]),
                str(entry["repo_target"]),
                str(entry["scope_target"]),
                " ".join(entry["titles"][:5]),
            ]
        ).lower()
        if normalized_query and normalized_query not in haystack:
            continue

        count = len(entry["urls"])
        subtitle = (
            f"{count} open PR(s) by you in {entry['repo_name']} | scope {entry['scope_target']}"
        )
        if entry["titles"]:
            subtitle += f" | {entry['titles'][0]}"

        items.append(
            {
                "uid": str(entry["repo_target"]),
                "title": str(entry["repo_name"]),
                "subtitle": subtitle,
                "arg": str(entry["repo_target"]),
                "autocomplete": str(entry["repo_name"]),
                "valid": True,
            }
        )

    items.sort(key=lambda item: (item["title"].lower(), item["arg"].lower()))
    return items


def run_open(target: str, host: str | None, limit: int, dry_run: bool) -> int:
    resolved = resolve_target(target, host)
    web_user = get_account_for_host(resolved["host"])

    if resolved["kind"] == "repo":
        if web_user:
            url = build_repo_author_url(
                resolved["host"], resolved["owner"], resolved["repo"], web_user
            )
            if dry_run:
                print(url)
                return 0

            subprocess.run(["open", url], check=False)
            print(
                f"Opened PR list for {resolved['owner']}/{resolved['repo']} "
                f"on {resolved['host']} filtered to {web_user}."
            )
            return 0

        prs = search_pull_requests_in_repo(
            resolved["host"], resolved["owner"], resolved["repo"], limit
        )
        label = f"{resolved['owner']}/{resolved['repo']} on {resolved['host']}"
    else:
        prs = search_pull_requests_in_org(resolved["host"], resolved["owner"], limit)
        label = f"{resolved['owner']} on {resolved['host']}"

    if not prs:
        raise AlfredOpenOrgPRError(
            f"No open PRs found for {label} authored by the configured gh account."
        )

    urls = [pr["url"] for pr in prs]
    if dry_run:
        for url in urls:
            print(url)
        return 0

    for url in urls:
        subprocess.run(["open", url], check=False)

    print(f"Opened {len(urls)} PR(s) for {label}.")
    return 0


def resolve_target(target: str, host: str | None) -> dict[str, str]:
    target = target.strip()
    if not target:
        raise AlfredOpenOrgPRError(
            "Missing target. Pass an alias, `host/owner`, or `host/owner/repo`."
        )

    alias_target = get_aliases().get(target.lower())
    if alias_target:
        target = alias_target["target"]

    if host:
        target = f"{host.strip()}/{target}"

    parts = [part.strip() for part in target.split("/") if part.strip()]
    if len(parts) == 2:
        return {"kind": "org", "host": parts[0], "owner": parts[1]}
    if len(parts) == 3:
        return {
            "kind": "repo",
            "host": parts[0],
            "owner": parts[1],
            "repo": parts[2],
        }

    raise AlfredOpenOrgPRError(
        f"Invalid target `{target}`. Expected alias, `host/owner`, or `host/owner/repo`."
    )


def build_repo_author_url(host: str, owner: str, repo: str, user: str) -> str:
    return f"https://{host}/{owner}/{repo}/pulls/{user}"


def get_cached_or_fetch_prs() -> list[dict[str, str]]:
    cached = load_cached_prs()
    if cached is not None:
        return cached

    scopes = get_scope_targets()
    if not scopes:
        raise AlfredOpenOrgPRError(
            f"No scopes configured. Add `scopes` to {CONFIG_PATH}."
        )

    all_prs: list[dict[str, str]] = []
    for scope_target in scopes:
        host, owner = parse_scope_target(scope_target)
        prs = search_pull_requests_in_org(host, owner, DEFAULT_SEARCH_LIMIT)
        for pr in prs:
            repo = pr.get("repository", {})
            repo_name = repo.get("nameWithOwner") or repo.get("name") or owner
            all_prs.append(
                {
                    "scope_target": scope_target,
                    "host": host,
                    "owner": owner,
                    "repo_name": repo_name,
                    "repo_target": f"{host}/{repo_name}",
                    "title": pr["title"],
                    "url": pr["url"],
                }
            )

    write_cached_prs(all_prs)
    return all_prs


def get_scope_targets() -> list[str]:
    config = load_config()
    raw_scopes = config.get("scopes")
    scopes: list[str] = []

    if isinstance(raw_scopes, list):
        for raw_scope in raw_scopes:
            if not isinstance(raw_scope, str):
                continue
            raw_scope = raw_scope.strip()
            if not raw_scope:
                continue

            alias_target = get_aliases().get(raw_scope.lower())
            scopes.append(alias_target["target"] if alias_target else raw_scope)

    if scopes:
        return scopes

    aliases = get_aliases()
    if aliases:
        return [alias["target"] for alias in aliases.values()]

    return [candidate["target"] for candidate in get_all_org_candidates()]


def parse_scope_target(target: str) -> tuple[str, str]:
    parts = [part.strip() for part in target.split("/") if part.strip()]
    if len(parts) != 2:
        raise AlfredOpenOrgPRError(
            f"Invalid scope `{target}`. Expected `host/owner`."
        )
    return parts[0], parts[1]


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


def search_pull_requests_in_org(host: str, owner: str, limit: int) -> list[dict[str, object]]:
    fields = "url,title,repository"
    return run_gh_json(
        [
            "search",
            "prs",
            "--owner",
            owner,
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


def search_pull_requests_in_repo(
    host: str, owner: str, repo: str, limit: int
) -> list[dict[str, object]]:
    fields = "url,title,repository"
    return run_gh_json(
        [
            "search",
            "prs",
            "--repo",
            f"{owner}/{repo}",
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
        auth_user = get_account_for_host(host)
        if auth_user:
            token = get_auth_token(host, auth_user)
            if host == "github.com" or host.endswith(".ghe.com"):
                env["GH_TOKEN"] = token
            else:
                env["GH_ENTERPRISE_TOKEN"] = token

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


def load_config() -> dict[str, object]:
    try:
        payload = json.loads(CONFIG_PATH.read_text())
    except FileNotFoundError:
        return {}
    except json.JSONDecodeError as exc:
        raise AlfredOpenOrgPRError(f"Invalid config file at {CONFIG_PATH}: {exc}") from exc

    if not isinstance(payload, dict):
        raise AlfredOpenOrgPRError(f"Invalid config file at {CONFIG_PATH}: expected an object")
    return payload


def get_account_for_host(host: str) -> str | None:
    config = load_config()
    accounts = config.get("accounts", {})
    if not isinstance(accounts, dict):
        return None

    account = accounts.get(host)
    if isinstance(account, str) and account.strip():
        return account.strip()
    return None


def get_aliases() -> dict[str, dict[str, str]]:
    config = load_config()
    aliases = config.get("aliases", {})
    if not isinstance(aliases, dict):
        return {}

    normalized: dict[str, dict[str, str]] = {}
    for alias, value in aliases.items():
        if not isinstance(alias, str) or not alias.strip():
            continue

        if isinstance(value, str):
            target = value.strip()
        elif isinstance(value, dict) and isinstance(value.get("target"), str):
            target = value["target"].strip()
        else:
            continue

        if target:
            normalized[alias.strip().lower()] = {"alias": alias.strip(), "target": target}

    return normalized


def get_auth_token(host: str, user: str) -> str:
    cache_key = (host, user)
    if cache_key in TOKEN_CACHE:
        return TOKEN_CACHE[cache_key]

    env = os.environ.copy()
    env.pop("GH_TOKEN", None)
    env.pop("GITHUB_TOKEN", None)
    env.pop("GH_ENTERPRISE_TOKEN", None)
    env.pop("GITHUB_ENTERPRISE_TOKEN", None)
    env.pop("GH_HOST", None)

    result = subprocess.run(
        ["gh", "auth", "token", "-h", host, "-u", user],
        capture_output=True,
        text=True,
        env=env,
        check=False,
    )
    if result.returncode != 0:
        details = (result.stderr or result.stdout).strip() or "unknown gh auth token failure"
        raise AlfredOpenOrgPRError(
            f"Failed to get token for {user} on {host}: {details}"
        )

    token = result.stdout.strip()
    if not token:
        raise AlfredOpenOrgPRError(f"Empty token returned for {user} on {host}")

    TOKEN_CACHE[cache_key] = token
    return token


def load_cached_orgs() -> list[dict[str, str]] | None:
    try:
        payload = json.loads(ORG_CACHE_PATH.read_text())
    except FileNotFoundError:
        return None
    except json.JSONDecodeError:
        return None

    generated_at = payload.get("generated_at", 0)
    if time.time() - generated_at > ORG_CACHE_TTL_SECONDS:
        return None

    orgs = payload.get("orgs")
    if not isinstance(orgs, list):
        return None

    return orgs


def write_cached_orgs(orgs: list[dict[str, str]]) -> None:
    CACHE_DIR.mkdir(parents=True, exist_ok=True)
    ORG_CACHE_PATH.write_text(json.dumps({"generated_at": time.time(), "orgs": orgs}))


def load_cached_prs() -> list[dict[str, str]] | None:
    try:
        payload = json.loads(PR_CACHE_PATH.read_text())
    except FileNotFoundError:
        return None
    except json.JSONDecodeError:
        return None

    generated_at = payload.get("generated_at", 0)
    if time.time() - generated_at > PR_CACHE_TTL_SECONDS:
        return None

    prs = payload.get("prs")
    if not isinstance(prs, list):
        return None

    return prs


def write_cached_prs(prs: list[dict[str, str]]) -> None:
    CACHE_DIR.mkdir(parents=True, exist_ok=True)
    PR_CACHE_PATH.write_text(json.dumps({"generated_at": time.time(), "prs": prs}))


def print_alfred_items(items: list[dict[str, object]]) -> None:
    print(json.dumps({"items": items}))


if __name__ == "__main__":
    sys.exit(main())
