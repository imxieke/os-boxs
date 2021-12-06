# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "~/.boxs/etc/p10k/p10k-instant-prompt.zsh" ]]; then
  source ~/.boxs/etc/p10k/p10k-instant-prompt.zsh
fi

###
 # @Author: Cloudflying
 # @Date: 2021-09-19 01:49:42
 # @LastEditTime: 2021-12-06 15:02:12
 # @LastEditors: Cloudflying
 # @Description: 
 # @FilePath: /.boxs/conf/.zshrc
### 

export ZSH=$HOME/.oh-my-zsh
# Check zsh load time for debug
# zmodload zsh/zprof
# If you come from bash you might have to change your $PATH.

# https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME='strug'
# ZSH_THEME='robbyrussell'

if [[ -f ~/.boxs/opt/zplug/init.zsh ]]; then
    source ~/.boxs/opt/zplug/init.zsh
    ZPLUG_HOME=~/.boxs/conf/zplug
	ZPLUG_PROTOCOL=HTTPS
	ZPLUG_BIN=${ZPLUG_HOME}/bin
	ZPLUG_CACHE_DIR=${ZPLUG_HOME}/cache
	ZPLUG_REPOS=${ZPLUG_HOME}/repos
	ZPLUG_LOADFILE=${ZPLUG_HOME}/packages.zsh
	ZPLUG_ERROR_LOG=${BOXS_LOGS}/zplug.log
	ZPLUG_LOG_LOAD_SUCCESS=true
	ZPLUG_LOG_LOAD_FAILURE=true
	mkdir -p ${ZPLUG_HOME}
fi

# Make sure to use double quotes
# Use the package as a command
# And accept glob patterns (e.g., brace, wildcard, ...)
# zplug "Jxck/dotfiles", as:command, use:"bin/{histuniq,color}"
# zplug "zdharma-continuum/fast-syntax-highlighting"
zplug "zsh-users/zsh-syntax-highlighting"
# zplug "zsh-users/zsh-history-substring-search"
# zplug "marlonrichert/zsh-autocomplete"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
# zplug "jeffreytse/zsh-vi-mode"
# zplug "agkozak/zsh-z"
# zplug "supercrabtree/k"
zplug "MichaelAquilina/zsh-you-should-use"
# zplug "mafredri/zsh-async", from:"github", use:"async.zsh"
# zplug "wfxr/formarks"
# zplug "Aloxaf/fzf-tab"
# zplug "unixorn/fzf-zsh-plugin"
zplug "chitoku-k/fzf-zsh-completions"
# zplug "yuki-yano/fzf-preview.zsh"
zplug "trystan2k/zsh-tab-title"
zplug 'romkatv/powerlevel10k', as:theme, depth:1

if [[ $(uname -s) == 'Darwin' ]]; then
	plugins=(macos)
fi

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# 加载插件
# zplug load --verbose
zplug load
zplug clear
zplug clean --force

plugins+=(git docker docker-compose fzf vagrant vagrant-prompt)

HISTFILE="$HOME/.zsh_history" # The path to the history file.
HISTSIZE=50000                                          # The maximum number of events to save in the internal history.
SAVEHIST=50000                                          # The maximum number of events to save in the history file.

source $ZSH/oh-my-zsh.sh

# 用户自定义配置

[ -f ~/.boxs/conf/.boxsrc ] && source ~/.boxs/conf/.boxsrc

# quotes 虽然我看不懂 但是不妨碍我装逼
fortune -s | cowsay

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.boxs/conf/.p10k.zsh ]] || source ~/.boxs/conf/.p10k.zsh
