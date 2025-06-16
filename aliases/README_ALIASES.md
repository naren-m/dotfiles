# Alias Management System

This directory contains a comprehensive alias management system with searchable documentation.

## Files Overview

- `aliases` - Main alias file with general purpose aliases and functions
- `aliases_cisco` - Cisco/work-specific aliases 
- `aliases_docker` - Docker container management aliases
- `aliases_kubectl` - Kubernetes management aliases  
- `aliases_mac` - macOS-specific aliases and utilities
- `aliases_mac_m1` - Apple Silicon Mac-specific path configurations
- `aliases_work` - Work environment aliases (legacy Cisco stuff)
- `deep_learning` - Deep learning environment setup (CUDA, Torch)
- `alias_cheatsheet.txt` - Comprehensive documentation of all aliases

## Searchable Cheatsheet

### Quick Usage
```bash
# Search for aliases interactively with fzf
acheat              # Opens fzf interface to search all aliases
alias_help          # Same as acheat

# Search for specific terms
salias docker       # Search for docker-related aliases
search_alias k8s    # Search for kubernetes aliases

# Show all aliases sorted
show_all_aliases    # Display all documented aliases
```

### How the Search Works

1. **Interactive Search (`acheat`)**:
   - Uses fzf for fuzzy searching
   - Shows descriptions alongside aliases
   - Press `/` to start searching
   - Press `Enter` to copy the alias name to clipboard
   - Ctrl+C to exit

2. **Term Search (`salias <term>`)**:
   - Searches for aliases containing the specified term
   - Case-insensitive search
   - Shows matching lines with descriptions

3. **Full List (`show_all_aliases`)**:
   - Shows all aliases in alphabetical order
   - Includes descriptions for easy reference

## Categories

### Navigation & File Management
- `ll`, `ls` variants for listing files
- `..`, `.2`, `.3`, `.4` for going up directories  
- `mcd`, `cd`, navigation shortcuts
- `extract`, `zipf` for archives

### Development Tools  
- `git_repo`, `batdiff` for git operations
- `preview`, `cview` for file viewing
- `ctags`, `gentags` for code tagging

### System Management
- `memHogsTop`, `cpu_hogs` for process monitoring
- `myip`, `netCons` for networking
- `flushDNS`, `lsock` for network debugging

### Container & Cloud
- Docker: `di`, `dps`, `drm*` series
- Kubernetes: `k`, `kg*`, `kuc` series with fzf integration
- Cisco tools: `sim_*`, `wit_*` functions

### Productivity
- Note taking: `note`, `todo`, `nls` functions  
- Task management: `tdone`, `tlist` with TaskWarrior
- Quick access: `desk`, `docs`, `proj` for common directories

## Adding New Aliases

1. Add the alias to the appropriate file (`aliases_*`)
2. Document it in `alias_cheatsheet.txt` following this format:
   ```
   alias_name      # Description of what the alias does
   ```
3. For functions, add them to the "FUNCTIONS" section at the bottom

## Requirements

- `fzf` - For interactive searching
- `bat` - For syntax-highlighted previews (optional)
- `pbcopy` - For copying to clipboard (macOS)

## Tips

- Use `acheat` as your go-to command when you can't remember an alias
- The search is fuzzy, so partial matches work great
- All aliases are organized by category for easy browsing
- Functions include parameter information in the documentation