# Exit if the shell is not interactive!!!
if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

if [ -f ~/.aliases_work ]; then
    . ~/.aliases_work
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/narenmudivarthy/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
