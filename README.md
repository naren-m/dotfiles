# Dotfiles

Personal dotfiles for Zsh, Vim, tmux, and alias management.

## Quick Start

```bash
# Clone
git clone https://github.com/naren-m/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Install plugins (oh-my-zsh, powerlevel10k, fzf-tab, etc.)
./get_plugins.sh

# Install dotfiles (creates symlinks, backs up originals to backup/)
./bootstrap2.sh
```

## What's Inside

- **Zsh** — Oh-My-Zsh with PowerLevel10k, syntax highlighting, autosuggestions, fzf-tab
- **Vim** — Modular config with vim-plug, NERDTree, fzf, lightline, ALE
- **tmux** — 256-color, vim-aware pane navigation, resurrect/continuum
- **Aliases** — Searchable system with `acheat` (fzf), organized by category

## Alias Search

```bash
acheat              # Interactive fuzzy search through all aliases
salias docker       # Search for docker-related aliases
show_all_aliases    # Display all aliases sorted
```

## Cheatsheet

- [Vim Cheatsheet](https://github.com/naren-m/dotfiles/wiki/Vim-Cheatsheet)

## References

- [luan vim files](https://github.com/luan/vimfiles)
