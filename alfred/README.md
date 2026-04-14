# Alfred GitHub PR Opener

This utility finds repositories that currently have your open PRs, then lets
you select a repo and open your filtered PR list page in the browser. It uses your existing
`gh` authentication, including enterprise hosts.

## Files

- `alfred_open_org_prs.py`: main utility
- `alfred_open_org_prs.json`: aliases, account selection, and search scopes

## Quick CLI use

```bash
/usr/bin/python3 /Users/nmudivar/dotfiles/alfred/alfred_open_org_prs.py alfred
/usr/bin/python3 /Users/nmudivar/dotfiles/alfred/alfred_open_org_prs.py open github.com/nd-org-git/e2e --dry-run
```

The current config pins:

- `github.com` to the `nmudivar_cisco` `gh` account
- `nd` as an alias for `github.com/nd-org-git`
- the search scope to `nd`

## Alfred setup

### Option 1: Simple keyword

1. Create a new Alfred workflow.
2. Add a `Keyword` object. Example keyword: `myprs`
3. Connect it to a `Run Script` object.
4. Set the script language to `/bin/zsh`.
5. Set `with input as` to `argv`.
6. Use this script:

```zsh
/usr/bin/python3 /Users/nmudivar/dotfiles/alfred/alfred_open_org_prs.py open "$1"
```

This only works well if you already know the exact repo target.

### Option 2: Better UX with Script Filter

This is the mode you want. It shows repos that currently have your open PRs.

1. Create a `Script Filter` object with keyword `myprs`.
2. Set the script language to `/bin/zsh`.
3. Set `with input as` to `argv`.
4. Use this script:

```zsh
/usr/bin/python3 /Users/nmudivar/dotfiles/alfred/alfred_open_org_prs.py alfred "$1"
```

5. Connect that to a `Run Script` object.
6. Set the second script language to `/bin/zsh`.
7. Set `with input as` to `argv`.
8. Use this script:

```zsh
/usr/bin/python3 /Users/nmudivar/dotfiles/alfred/alfred_open_org_prs.py open "$1"
```

Alfred will show repositories such as `nd-org-git/e2e`; pressing Enter opens a
single page like `https://github.com/nd-org-git/e2e/pulls/nmudivar_cisco`.

## Notes

- Alfred can point directly at the file in `~/dotfiles`; no symlink is required unless you want one.
- `alfred_open_org_prs.json` lets you pin a specific `gh` account per host, define aliases like `nd -> github.com/nd-org-git`, and choose which org scopes Alfred searches.
- The org list is cached for 10 minutes in `~/Library/Caches/alfred-open-org-prs/orgs.json`.
- The PR list is cached for 90 seconds in `~/Library/Caches/alfred-open-org-prs/prs.json`.
- Repo discovery uses: `gh search prs --owner <org> --author @me --state open`
- For repo selections on hosts with a pinned account in the config, the action opens `https://<host>/<owner>/<repo>/pulls/<account>`.
- The `nd{...json...}` error happens when Alfred is configured to inject query text directly into stdout. Using `$1` with `with input as argv` avoids that.
