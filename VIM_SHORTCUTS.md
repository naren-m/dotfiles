# Vim Configuration Shortcuts Reference

This document provides a comprehensive reference for all custom keyboard shortcuts and mappings in your vim configuration.

**Leader Key**: `,` (comma)

## Navigation & Movement

| Shortcut | Description | Location |
|----------|-------------|----------|
| `Shift+Tab` | Toggle fold at current position | mappings.vim:3 |
| `Ctrl+j` | Move to window below | mappings.vim:6 |
| `Ctrl+k` | Move to window above | mappings.vim:7 |
| `Ctrl+h` | Move to window left | mappings.vim:8 |
| `Ctrl+l` | Move to window right | mappings.vim:9 |
| `Tab` | Next buffer | mappings.vim:12 |
| `Shift+Tab` | Previous buffer | mappings.vim:13 |
| `Ctrl+r` | Toggle relative line numbers | basic.vim:58 |

## Window Management

| Shortcut | Description | Location |
|----------|-------------|----------|
| `,hs` | Horizontal split | mappings.vim:17 |
| `,vs` | Vertical split | mappings.vim:18 |
| `,sc` | Close current window | mappings.vim:19 |

## File Operations

| Shortcut | Description | Location |
|----------|-------------|----------|
| `Enter` | Save file (in normal buffers) | basic.vim:31 |
| `,w` | Remove trailing whitespace | mappings.vim:22 |

## NERDTree (File Explorer)

| Shortcut | Description | Location |
|----------|-------------|----------|
| `,n` | Focus NERDTree | mappings.vim:25 |
| `,nt` | Toggle NERDTree | mappings.vim:26 |
| `,f` | Find current file in NERDTree | mappings.vim:27 |

## Buffer Navigation (Lightline)

| Shortcut | Description | Location |
|----------|-------------|----------|
| `,1` | Go to buffer 1 | mappings.vim:87 |
| `,2` | Go to buffer 2 | mappings.vim:88 |
| `,3` | Go to buffer 3 | mappings.vim:89 |
| `,4` | Go to buffer 4 | mappings.vim:90 |
| `,5` | Go to buffer 5 | mappings.vim:91 |
| `,6` | Go to buffer 6 | mappings.vim:92 |
| `,7` | Go to buffer 7 | mappings.vim:93 |
| `,8` | Go to buffer 8 | mappings.vim:94 |
| `,9` | Go to buffer 9 | mappings.vim:95 |
| `,0` | Go to buffer 10 | mappings.vim:96 |

## Search & Find (FZF)

| Shortcut | Description | Location |
|----------|-------------|----------|
| `Ctrl+p` | Find files | mappings.vim:69 |
| `,f` | Find files (duplicate with NERDTree) | mappings.vim:70 |
| `,h` | File history | mappings.vim:71 |
| `,bt` | Buffer tags | mappings.vim:72 |
| `,bl` | Buffer lines | mappings.vim:73 |
| `,tt` | Tags | mappings.vim:74 |
| `,b` | Buffers | mappings.vim:75 |
| `,c` | Color schemes | mappings.vim:76 |
| `,k` | Search current word with Ag | mappings.vim:52 |

## Code Editing & Formatting

| Shortcut | Description | Location |
|----------|-------------|----------|
| `ga` (visual) | Easy align in visual mode | mappings.vim:45 |
| `ga` (normal) | Easy align for motion/text object | mappings.vim:48 |
| `,ci` | Comment/uncomment line | mappings.vim:80 |
| `,/` | Comment/uncomment line (alternative) | mappings.vim:83 |

## Task Management

| Shortcut | Description | Location |
|----------|-------------|----------|
| `,t` | Open Task Warrior in new tab | mappings.vim:55 |

## GUI-Specific (when running in GUI mode)

| Shortcut | Description | Location |
|----------|-------------|----------|
| `Ctrl+Shift+x` | Cut to system clipboard | mappings.vim:34 |
| `Ctrl+Shift+c` | Copy to system clipboard | mappings.vim:35 |
| `Ctrl+Shift+v` | Paste from system clipboard | mappings.vim:36 |

## Cscope (Code Navigation) - Advanced

### Horizontal Split
| Shortcut | Description | Location |
|----------|-------------|----------|
| `Ctrl+\+s` | Find symbol | cscope_plugin.vim:89 |
| `Ctrl+\+g` | Find definition | cscope_plugin.vim:90 |
| `Ctrl+\+c` | Find functions calling this | cscope_plugin.vim:91 |
| `Ctrl+\+t` | Find text string | cscope_plugin.vim:92 |
| `Ctrl+\+e` | Find egrep pattern | cscope_plugin.vim:93 |
| `Ctrl+\+f` | Find file | cscope_plugin.vim:94 |
| `Ctrl+\+i` | Find files including this file | cscope_plugin.vim:95 |
| `Ctrl+\+d` | Find functions called by this | cscope_plugin.vim:96 |

### Vertical Split
| Shortcut | Description | Location |
|----------|-------------|----------|
| `Ctrl+c+s` | Find symbol (vertical split) | cscope_plugin.vim:123 |
| `Ctrl+c+g` | Find definition (vertical split) | cscope_plugin.vim:124 |
| `Ctrl+c+c` | Find functions calling this (vertical split) | cscope_plugin.vim:125 |
| `Ctrl+c+t` | Find text string (vertical split) | cscope_plugin.vim:126 |
| `Ctrl+c+e` | Find egrep pattern (vertical split) | cscope_plugin.vim:127 |
| `Ctrl+c+f` | Find file (vertical split) | cscope_plugin.vim:128 |
| `Ctrl+c+i` | Find files including this file (vertical split) | cscope_plugin.vim:129 |
| `Ctrl+c+d` | Find functions called by this (vertical split) | cscope_plugin.vim:130 |

## Plugin Management (Vim-Plug) - Used in Plugin Status Buffer

| Shortcut | Description | Context |
|----------|-------------|---------|
| `R` | Retry failed plugins | Plugin status buffer |
| `D` | Show plugin diff | Plugin status buffer |
| `S` | Show plugin status | Plugin status buffer |
| `U` | Update plugins | Plugin status buffer |
| `L` | Load plugins | Plugin status buffer |
| `q` | Quit plugin window | Plugin status buffer |

## Settings & Configuration

### Leader Key Configuration
- **Leader key**: `,` (comma) - defined in basic.vim:109
- **Local leader key**: `-` (dash) - defined in basic.vim:110

### Important Settings
- **Mouse enabled**: `set mouse=a` (basic.vim:34)
- **Clipboard**: Uses system clipboard `set clipboard=unnamed` (basic.vim:37)
- **Auto-save on Enter**: Enter key saves file in normal buffers
- **Line numbers**: Enabled with `set number` (basic.vim:47)
- **Color column**: Shows at 80 characters

## Potential Conflicts & Notes

⚠️ **Mapping Conflicts Resolved**:
- `,f` is mapped to both NERDTreeFind and FZF Files - **NERDTree takes precedence**
- Previous conflict with `,t` has been resolved - now only maps to Task Warrior

## Plugin Dependencies

This configuration requires the following plugins to be installed:
- **NERDTree**: File explorer
- **FZF**: Fuzzy finder
- **Lightline**: Status line
- **Ag**: Text search
- **Task Warrior**: Task management
- **Easy Align**: Text alignment
- **Cscope**: Code navigation
- **Commentary/TComment**: Code commenting

## Usage Tips

1. **Quick file access**: Use `Ctrl+p` for fast file finding
2. **Buffer management**: Use `,1` through `,9` for quick buffer switching
3. **Code navigation**: Use cscope mappings (`Ctrl+\+g`) for jumping to definitions
4. **Window management**: Use `Ctrl+hjkl` for vim-like window navigation
5. **Text cleanup**: Use `,w` to remove trailing whitespace before committing code

---
*Generated from vim configuration files in /Users/nmudivar/dotfiles/vimfiles/*