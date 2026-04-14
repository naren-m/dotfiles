# Setting Up Vim for Command+Click File Opening

This guide shows how to set up vim to open files when you Command+click them in Finder or other applications.

## Quick Setup (Recommended)

### 1. Use the Terminal Script
The `scripts/open-with-vim.sh` script opens files in vim within Terminal:

```bash
# Use the script directly
~/dotfiles/scripts/open-with-vim.sh path/to/file

# Or use the alias (after sourcing aliases)
vimopen path/to/file
```

### 2. Set Default Text Editor
Your shell environment is configured with:
```bash
export EDITOR=vim
export VISUAL=vim
```

## GUI Integration Options

### Option A: Install MacVim (Best GUI Experience)
```bash
# Run the installation script
~/dotfiles/scripts/install-macvim.sh

# Or manually:
brew install --cask macvim
```

After installing MacVim:
1. Open **System Preferences** → **Extensions** → **Default Apps**
2. Set **MacVim** as default for text files
3. Or right-click any text file → **Open With** → **MacVim** → **Always Open With**

### Option B: Set File Associations Manually

1. **Right-click** on any text file in Finder
2. Choose **Get Info**
3. In the **Open with:** section, select the terminal script or MacVim
4. Click **Change All...** to apply to all similar files

## File Types to Associate

Common file extensions to associate with vim:
- `.txt`, `.md`, `.py`, `.js`, `.html`, `.css`, `.json`
- `.vim`, `.sh`, `.conf`, `.log`, `.yml`, `.yaml`
- Programming files: `.c`, `.cpp`, `.java`, `.go`, `.rs`

## Using the Setup

### Command Line
```bash
# Open file in terminal vim
vimopen filename.txt

# Direct script usage
~/dotfiles/scripts/open-with-vim.sh filename.txt
```

### GUI (after MacVim install)
- **Double-click** files in Finder
- **Command+click** in applications
- **Right-click** → **Open With** → **MacVim**

### Quick Commands
```bash
# Open current directory files
find . -name "*.py" -exec vimopen {} \;

# Open specific file types
vimopen *.md
```

## Environment Variables Set

In your shell configuration:
```bash
export EDITOR=vim          # Default editor for git, cron, etc.
export VISUAL=vim          # Visual editor for applications
alias vimopen="~/dotfiles/scripts/open-with-vim.sh"  # Quick file opener
```

## Troubleshooting

### Script Not Working
```bash
# Check if script is executable
ls -la ~/dotfiles/scripts/open-with-vim.sh

# Make executable if needed
chmod +x ~/dotfiles/scripts/open-with-vim.sh
```

### Terminal Not Opening
- Ensure **Terminal.app** has necessary permissions in **System Preferences** → **Security & Privacy**
- Try the MacVim option for better GUI integration

### File Association Not Sticking
- Use **duti** (install with `brew install duti`) for more reliable file associations:
```bash
# Set vim for plain text files
duti -s com.apple.Terminal txt all
```

## Benefits

✅ **Consistent Environment**: Uses your custom vim configuration  
✅ **Quick Access**: Command+click opens files instantly in vim  
✅ **Terminal Integration**: Works within your terminal workflow  
✅ **Flexible**: Works with both GUI and command-line workflows  

Your vim configuration with all custom shortcuts and plugins will work seamlessly!