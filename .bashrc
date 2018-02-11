#Exit if the shell is not interactive!!!
if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

if [ -f ~/.aliases_work ]; then
    . ~/.aliases_work
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
