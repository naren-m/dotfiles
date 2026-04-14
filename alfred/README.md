# Alfred GitHub PR Opener

This utility opens every open PR you authored in a given GitHub organization.
It uses your existing `gh` authentication, including enterprise hosts.

## Files

- `alfred_open_org_prs.py`: main utility

## Quick CLI use

```bash
/usr/bin/python3 /Users/nmudivar/dotfiles/alfred/alfred_open_org_prs.py open nd --host aci-github.cisco.com --dry-run
/usr/bin/python3 /Users/nmudivar/dotfiles/alfred/alfred_open_org_prs.py open aci-github.cisco.com/nd
```

If the org name is unique across your authenticated hosts, you can also use:

```bash
/usr/bin/python3 /Users/nmudivar/dotfiles/alfred/alfred_open_org_prs.py open nd
```

## Alfred setup

### Option 1: Simple keyword

1. Create a new Alfred workflow.
2. Add a `Keyword` object. Example keyword: `myprs`
3. Connect it to a `Run Script` object.
4. Set the script language to `/bin/zsh`.
5. Use this script:

```zsh
/usr/bin/python3 /Users/nmudivar/dotfiles/alfred/alfred_open_org_prs.py open "{query}"
```

Usage:

- `myprs nd`
- `myprs aci-github.cisco.com/nd`

### Option 2: Better UX with Script Filter

This gives you fuzzy org lookup from all hosts in `gh auth status`.

1. Create a `Script Filter` object with keyword `myprs`.
2. Set the script language to `/bin/zsh`.
3. Use this script:

```zsh
/usr/bin/python3 /Users/nmudivar/dotfiles/alfred/alfred_open_org_prs.py alfred "{query}"
```

4. Connect that to a `Run Script` object.
5. Set the second script to:

```zsh
/usr/bin/python3 /Users/nmudivar/dotfiles/alfred/alfred_open_org_prs.py open "{query}"
```

Alfred will show organizations such as `github3.cisco.com/ROBOT` or
`aci-github.cisco.com/nd`; pressing Enter opens all of your open PRs for the
selected org.

## Notes

- Alfred can point directly at the file in `~/dotfiles`; no symlink is required unless you want one.
- The org list is cached for 10 minutes in `~/Library/Caches/alfred-open-org-prs/orgs.json`.
- PR lookup uses: `gh search prs --owner <org> --author @me --state open`
- If the same org name exists on multiple hosts, pass `host/org`.
