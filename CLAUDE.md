# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a personal dotfiles repository containing shell configuration, Vim settings, and comprehensive alias management for development environments. The repository uses symbolic linking to install configurations into the home directory.

### Key Components

- **Shell Configuration**: Oh-My-Zsh setup with PowerLevel10k theme and various plugins (syntax highlighting, autosuggestions, fzf-tab)
- **Vim Configuration**: Modular Vim setup split across multiple files for organization
- **Alias System**: Comprehensive, searchable alias management with documentation and fzf integration
- **Bootstrap Scripts**: Automated setup and plugin installation

### Directory Structure

```
├── aliases/                    # Alias management system
│   ├── aliases                # Main aliases file
│   ├── aliases_docker         # Docker-specific aliases
│   ├── aliases_kubectl        # Kubernetes aliases with fzf integration
│   ├── aliases_mac*           # macOS-specific aliases
│   ├── aliases_work           # Work environment aliases
│   ├── deep_learning          # ML/AI environment setup
│   └── alias_cheatsheet.txt   # Searchable alias documentation
├── vimfiles/                  # Vim configuration
│   ├── basic.vim              # Core Vim settings
│   ├── mappings.vim           # Key mappings
│   ├── plugins.vim            # Plugin configurations
│   └── vim/                   # Vim runtime files
├── zsh_themes/                # Custom Zsh themes
└── zsh-autosuggestions/       # Zsh plugin (local copy)
```

## Common Commands

### Setup and Installation
```bash
# Install dotfiles (backs up existing configs)
./bootstrap2.sh

# Force install without prompts
./bootstrap2.sh --force

# Install oh-my-zsh and plugins
./get_plugins.sh
```

### Alias System Usage
```bash
# Interactive alias search with fzf
acheat

# Search for specific aliases
salias docker
search_alias k8s

# Show all documented aliases
show_all_aliases
```

### Development Workflow

The repository doesn't use traditional build/test commands as it's a configuration repository. Instead:

1. **Testing Changes**: Source updated files directly or restart shell
2. **Validation**: Check that symbolic links are created correctly after running bootstrap
3. **Documentation**: Update `alias_cheatsheet.txt` when adding new aliases

## Important Notes

- All configuration files are symlinked from the repository to home directory
- The alias system includes comprehensive documentation and search functionality
- Vim configuration is modular for easier maintenance
- Bootstrap script backs up original files to `backup/` directory
- Requires oh-my-zsh, fzf, and other dependencies installed by `get_plugins.sh`

## Alias Categories

- **Navigation**: Directory traversal and file management
- **Development**: Git, code viewing, and development tools  
- **System**: Process monitoring and network utilities
- **Containers**: Docker and Kubernetes management with fzf integration
- **Productivity**: Note-taking and task management