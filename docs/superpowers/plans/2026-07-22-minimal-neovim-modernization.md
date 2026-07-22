# Minimal Neovim Modernization Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add modern Go, Python, YAML, and Shell LSP navigation to the existing Neovim setup without replacing its Vim configuration.

**Architecture:** A tracked Neovim entrypoint continues to source `~/.vimrc`, then enables four built-in LSP configurations supplied by `nvim-lspconfig`. Existing vim-plug and fzf navigation remain unchanged.

**Tech Stack:** Neovim 0.12.1, vim-plug, nvim-lspconfig, Homebrew language servers

## Global Constraints

- Keep the existing Vim setup and fzf mappings.
- Add no Neovim distribution, second plugin manager, completion framework, file tree, theme, or duplicate fuzzy finder.
- Preserve unrelated working-tree changes.

---

### Task 1: Install and enable minimal LSP navigation

**Files:**
- Create: `vimfiles/nvim/init.vim`
- Modify: `vimfiles/plugins.vim`
- Modify: `bootstrap2.sh`

**Interfaces:**
- Consumes: existing `~/.vimrc`, vim-plug, and `fzf.vim` configuration
- Produces: enabled `gopls`, `pyright`, `yamlls`, and `bashls` LSP configurations

- [ ] **Step 1: Run the failing capability check**

```bash
rtk proxy nvim --headless "+lua if not pcall(require, 'lspconfig') then vim.cmd('cquit') end" +qa
```

Expected: exit 1 because the plugin is not installed.

- [ ] **Step 2: Add the Neovim-only plugin declaration**

Add before `call plug#end()` in `vimfiles/plugins.vim`:

```vim
    if has('nvim')
        Plug 'neovim/nvim-lspconfig'
    endif
```

- [ ] **Step 3: Create the tracked Neovim entrypoint**

Create `vimfiles/nvim/init.vim`:

```vim
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

lua << EOF
vim.lsp.enable({ "gopls", "pyright", "yamlls", "bashls" })
EOF
```

- [ ] **Step 4: Make bootstrap install the entrypoint safely**

In `bootstrap2.sh`, back up a regular existing Neovim config alongside the
other backups:

```bash
if [ ! -L ~/.config/nvim/init.vim ]; then
    mv ~/.config/nvim/init.vim $PWD/backup/nvim-init.vim.orig 2>/dev/null
fi
```

Then add the Neovim link beside the Vim links:

```bash
mkdir -p ~/.config/nvim
ln -sfn $PWD/vimfiles/nvim/init.vim ~/.config/nvim/init.vim
```

- [ ] **Step 5: Install plugin and language servers**

```bash
rtk proxy nvim --headless +PlugInstall +qa
rtk proxy brew install gopls pyright yaml-language-server bash-language-server
```

Expected: `nvim-lspconfig` installed under `~/.vim/plugged`; all four formulae installed or reported already installed.

- [ ] **Step 6: Activate the tracked entrypoint on this machine**

```bash
rtk proxy mv /home/nmudivar/.config/nvim/init.vim /home/nmudivar/dotfiles/backup/nvim-init.vim.orig
rtk proxy ln -s /home/nmudivar/dotfiles/vimfiles/nvim/init.vim /home/nmudivar/.config/nvim/init.vim
```

Expected: `~/.config/nvim/init.vim` resolves to the tracked entrypoint; prior 122-byte bridge remains recoverable in `backup/nvim-init.vim.orig`.

- [ ] **Step 7: Run green verification**

```bash
rtk proxy nvim --headless "+lua assert(pcall(require, 'lspconfig'))" "+lua for _, name in ipairs({ 'gopls', 'pyright', 'yamlls', 'bashls' }) do assert(vim.lsp.is_enabled(name), name .. ' disabled') end" "+lua assert(vim.fn.exists(':Files') == 2, 'fzf Files missing')" "+lua assert(vim.fn.maparg('grr', 'n') ~= '', 'grr references mapping missing')" +qa
rtk proxy which gopls
rtk proxy which pyright-langserver
rtk proxy which yaml-language-server
rtk proxy which bash-language-server
rtk proxy nvim --headless "+enew" "+file /tmp/codex-nvim-lsp.go" "+setfiletype go" "+lua assert(vim.wait(10000, function() return #vim.lsp.get_clients({ bufnr = 0, name = 'gopls' }) == 1 end), 'gopls did not attach')" +qa
rtk proxy nvim --headless "+enew" "+file /tmp/codex-nvim-lsp.py" "+setfiletype python" "+lua assert(vim.wait(10000, function() return #vim.lsp.get_clients({ bufnr = 0, name = 'pyright' }) == 1 end), 'pyright did not attach')" +qa
rtk proxy nvim --headless "+enew" "+file /tmp/codex-nvim-lsp.yaml" "+setfiletype yaml" "+lua assert(vim.wait(10000, function() return #vim.lsp.get_clients({ bufnr = 0, name = 'yamlls' }) == 1 end), 'yamlls did not attach')" +qa
rtk proxy nvim --headless "+enew" "+file /tmp/codex-nvim-lsp.sh" "+setfiletype sh" "+lua assert(vim.wait(10000, function() return #vim.lsp.get_clients({ bufnr = 0, name = 'bashls' }) == 1 end), 'bashls did not attach')" +qa
rtk proxy vim -Nu vimfiles/.vimrc -n -es +qa
rtk git diff --check
```

Expected: every command exits zero. `grr` invokes symbol references; `gd`,
`gri`, `gO`, `K`, `grn`, and `gra` retain Neovim 0.12 defaults.

- [ ] **Step 8: Commit only implementation files**

```bash
rtk git add vimfiles/nvim/init.vim vimfiles/plugins.vim bootstrap2.sh docs/superpowers/plans/2026-07-22-minimal-neovim-modernization.md
rtk git commit -m "feat: add minimal Neovim LSP setup"
```
