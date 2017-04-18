function box_name {
    [ -f ~/.box-name ] && cat ~/.box-name || echo ${SHORT_HOST:-$HOST}
}
PROMPT='%{$fg_bold[red]%}➜ %{$fg_bold[cyan]%}($(box_name)%)%{$fg_bold[green]%}%p %{$fg[cyan]%}%c %{$fg_bold[white]%}$(git_prompt_info)%{$fg_bold[white]%} % %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[white]%}) %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[white]%})"
