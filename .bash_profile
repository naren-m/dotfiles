# General Aliases
if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

# Aliases for work
if [ -f ~/.aliases_work ]; then
    . ~/.aliases_work
fi
# iterm shell integration
    test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
