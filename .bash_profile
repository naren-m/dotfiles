. `brew --prefix`/etc/profile.d/z.sh

if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

# iterm shell integration
    test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"