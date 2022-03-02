# General Aliases
if [ -f ~/.aliases ]; then
    source ~/.aliases
fi

# Aliases for work
if [ -f ~/.aliases_work ]; then
    source ~/.aliases_work
fi


# added by Anaconda3 5.2.0 installer
export PATH="/anaconda3/bin:$PATH"
. /anaconda3/etc/profile.d/conda.sh
ssh-add -l &> /dev/null
if [ "$?" == 2 ]; then
  test -r ~/.ssh-agent && \
    eval "$(<~/.ssh-agent)" > /dev/null

  ssh-add -l &> /dev/null
  if [ "$?" == 2 ]; then
    (umask 066; ssh-agent > ~/.ssh-agent)
    eval "$(< ~/.ssh-agent)" > /dev/null
    ssh-add
  fi
fi
