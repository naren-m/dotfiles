#Exit if the shell is not interactive!!!
if [ $?prompt == 0  ]; then
    exit
fi

if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

if [ -f ~/.aliases_work ]; then
    . ~/.aliases_work
fi
