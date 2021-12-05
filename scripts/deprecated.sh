#!/usr/bin/env bash
###
 # @Author: Cloudflying
 # @Date: 2021-12-03 23:38:08
 # @LastEditTime: 2021-12-03 23:38:08
 # @LastEditors: Cloudflying
 # @Description: 
 # @FilePath: /.boxs/scripts/deprecated.sh
### 

# 设置 fzf 自动补全
# if [[ -n "$(command -v fzf)" ]]; then
# 	if [[ "${OSNAME}" == 'Darwin' ]]; then
# 		source /usr/local/opt/fzf/shell/key-bindings.zsh
# 		source /usr/local/opt/fzf/shell/completion.zsh
# 	elif [[ "${OSNAME}" == 'Linux' ]]; then
# 		# alpine fzf-zsh-completion
# 		if [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
# 			source /usr/share/fzf/key-bindings.zsh
# 			source /usr/share/zsh/site-functions/_fzf
# 		# Ubuntu 20.04 , maybe can't found zsh file
# 		# Manual Download it
# 		# https://github.com/junegunn/fzf/tree/master/shell 
# 		elif [[ -f /usr/share/doc/fzf/examples/completion.zsh ]]; then
# 			source /usr/share/doc/fzf/examples/completion.zsh
# 			source /usr/share/doc/fzf/examples/key-bindings.zsh
# 		fi
# 	fi
# fi