#!/usr/bin/env bash
###
 # @Author: Cloudflying
 # @Date: 2021-06-21 12:46:09
 # @LastEditTime: 2021-12-06 18:46:18
 # @LastEditors: Cloudflying
 # @Description: Recovery Dotfile
 # @FilePath: /.boxs/scripts/recovery.sh
### 

# TODO
# 判断是否为软连接 为当前目录则不进行改变
DATEFORMAT=$(date "+%Y%m%d-%H%M%S")
BAK_DIR=~/.config/backup
CUR_DIR=~/.boxs
mkdir -p ${BAK_DIR}/conf

# deps git zsh neovim ca-certificates curl wget cowsay fortune
# debian /usr/games/cowsay

# 恢复
if [[ -f ~/.zshrc ]]; then
	mv ~/.zshrc ${BAK_DIR}/conf/.zshrc-${DATEFORMAT}
	ln -sf ~/.boxs/conf/.zshrc ~/.zshrc
else
	# 若不存在则创建软连接
	ln -sf ~/.boxs/conf/.zshrc ~/.zshrc
fi

# 修复 /usr/local/share/zsh/ 写入的非安全权限
# compaudit | xargs chmod g-w,o-w

if [[ ! -d ~/.oh-my-zsh ]]; then
	git clone --depth 1 https://e.coding.net/pkgs/oh-my-zsh/oh-my-zsh.git ~/.oh-my-zsh
else
	git -C ~/.oh-my-zsh pull
fi

if [[ -n "$(command -v nvim)" ]]; then
	if [[ ! -d ~/.config/nvim ]]; then
		ln -sf ~/.boxs/conf/nvim ~/.config/nvim
	fi
fi

_vscode()
{

	if [[ -f ~/.boxs/conf/app-export/vscode-extensions.txt ]]; then
		exts=$(cat ~/.boxs/conf/backup/vscode-extensions.txt)
		for ext in $exts
		do
			code --install-extension $ext
		done
		
	fi
}

# ln -s ~/.config/dotfile/conf/oh-my-zsh ~/.oh-my-zsh
# ln -s ~/.config/dotfile/conf/.zshrc ~/.zsh
# ln -s ~/.config/dotfile/conf/nvim ~/.config/nvim

# pip3 install pynvim