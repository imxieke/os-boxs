# Cloudflying custom zsh theme
# Time Tue Jul 17 2018

# local ret_status="
# %(?:%{$fg_bold[green]%}╭─ # `whoami`\
# %(?:%{$fg_bold[green]%}@\
# %(?:%{$fg_bold[red]%}`uname -n` \
# %(?:%{$fg_bold[blue]%}in \
# %(?:%{$fg_bold[red]%}`pwd`
# "

local username="%(?:%{$fg_bold[green]%}╭─ # `whoami`"
local hostname="%(?:%{$fg_bold[green]%}`uname -n`"
local ret_status="${username}@${hostname} in %~ "
local git_branch='$(git_prompt_info)%{$reset_color%}$(git_remote_status)'
#%(?:%{$fg_bold[green]%}➜:%{$fg_bold[red]%}➜
#username @ hostname in dir 

PROMPT="${ret_status} %{$fg[cyan]%}%c$(git_prompt_info)%{$reset_color%}$(git_remote_status)
%{$fg[green]%}╰\$ %{$reset_color%}"

ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
# ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg_bold[yellow]%}on "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
