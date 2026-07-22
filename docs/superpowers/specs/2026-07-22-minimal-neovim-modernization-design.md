# Minimal Neovim Modernization

## Goal

Keep the existing Vim setup while adding modern Neovim code navigation for Go,
Python, YAML, and Shell.

## Design

- Track a small Neovim entrypoint that loads the existing `~/.vimrc`.
- Add `nvim-lspconfig` through the existing vim-plug setup, only under Neovim.
- Enable `gopls`, `pyright`, `yamlls`, and `bashls` with Neovim's built-in LSP.
- Install those four language-server binaries through Homebrew on this machine.
- Keep existing `fzf.vim` file, buffer, line, and grep navigation.

Neovim 0.12 supplies the LSP mappings: `gd` for definition, `grr` for symbol
references, `gri` for implementations, `gO` for document symbols, `K` for
hover, `grn` for rename, and `gra` for code actions.

## Verification

- Neovim starts headlessly without errors.
- `nvim-lspconfig` loads and all four server executables exist.
- Each configured file type attaches its expected language server.
- Existing Vim and fzf mappings remain available.

## Non-goals

No Neovim distribution, second plugin manager, completion framework, file-tree
replacement, theme change, or duplicate fuzzy-finder plugin.
