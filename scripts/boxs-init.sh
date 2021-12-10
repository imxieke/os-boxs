#!/usr/bin/env bash


# Think
# 检测系统环境 先安装程序所需依赖
# 检测系统环境 及本地代理是否运行
# 开始部署 boxs 环境

DATEFORMAT=$(date "+%Y%m%d-%H%M%S")

# macOS
if [[ "$(uname -s)" == 'Darwin' ]];then
	OSNAME='Darwin'
elif [[ "$(uname -s)" == 'Linux' ]];then
	OSNAME=$(grep '^ID=' /etc/os-release | grep '^ID=' | awk =F '=' '{print $2}')
fi

# mkdir -p ~/.boxs/{backup,opt,logs}

# 存储自定义可执行文件 但是不存储到 boxs

mkdir -p ~/.bin

# deps git zsh neovim ca-certificates curl wget cowsay fortune
# debian /usr/games/cowsay

# 初始化系统检测
_init_check()
{
	echo "==> base run env checking"
	[ -z "$(command -v git)" ] && echo "command not found: git" && exit 1

	# 获取 boxs
	if [ ! -f ~/.boxs/conf/.boxsrc ];then

		[ -d ~/.boxs ] && mv ~/.boxs "~/.boxs.bak-$(date +%s)"

		BOXS_GIT_URL='https://e.coding.net/cloudflying/os-boxs/os-boxs.git'

		if [ -f ~/.ssh/known_hosts ] && [ -n "$(grep 'e\.coding\.net' ~/.ssh/known_hosts)" ] ;then
			BOXS_GIT_URL='git@e.coding.net:cloudflying/os-boxs/os-boxs.git'
		fi

		git clone --depth 1 ${BOXS_GIT_URL} ~/.boxs
	fi

	if [ -z "$(command -v clash)" ] && [ ! -f ~/.bin/clash ];then
		_install_clash
	fi

	if [ -z "$(command -v clash)" ] && [ ! -f ~/.bin/clash ]; then
		echo 'clash install failed, manual install it via: https://github.com/Dreamacro/clash/releases'
	fi

	CLASH_STATUS=$(ps -ax | grep clash | grep -v grep)
	if [ -z "${CLASH_STATUS}" ];then
		if [[ -n "$(command -v clash)" ]]; then
			clash -f ~/.boxs/conf/clash/config.yaml >> /tmp/clash.log &
		elif [[ -f ~/.bin/clash ]]; then
			~/.bin/clash -f ~/.boxs/conf/clash/config.yaml >> /tmp/clash.log &
		else
			echo "can't find clash bin in path"
			exit 1
		fi
	fi

	chmod -R +x ~/.bin 
	chmod -R +x ~/.boxs/bin
	~/.boxs/bin/all/set-sys-proxy
	echo "Configration All done, deploy now"
}

# 从远程获取文件
_fetch()
{
	if [[ -n "${2}" ]]; then
		_WGET_OUTPUT="-O $2"
		_AXEL_OUTPUT="-o $2"
	fi

	if [[ -n "$(command -v wget)" ]]; then
		wget -c --no-check-certificate $@ _WGET_OUTPUT
	elif [[ -n "$(command -v axel)" ]]; then
		axel -k -v -a -n 4 $@ _AXEL_OUTPUT
	fi
}

_init_brew()
{
	[ -z "$(command -v brew)" ] && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	if [[ -n "$(command -v brew)" ]]; then
		echo "==> Set Brew and tap mirrors"
		# Brew
		git -C "$(brew --repo)" remote set-url origin https://e.coding.net/pkgs/homebrew/brew.git

		# Cask
		if [[ -d /usr/local/Homebrew/Library/Taps/homebrew/homebrew-cask ]]; then
			git -C "$(brew --repo homebrew/cask)" remote set-url origin https://e.coding.net/pkgs/homebrew/homebrew-cask.git
		else
			brew tap homebrew/cask https://e.coding.net/pkgs/homebrew/homebrew-cask.git
		fi

		# Core
		if [[ -d /usr/local/Homebrew/Library/Taps/homebrew/homebrew-core ]]; then
			git -C "$(brew --repo homebrew/core)" remote set-url origin https://e.coding.net/pkgs/homebrew/homebrew-core.git
		else
			brew tap homebrew/core https://e.coding.net/pkgs/homebrew/homebrew-core.git
		fi

		if [[ -d /usr/local/Homebrew/Library/Taps/homebrew/homebrew-services ]]; then
			git -C "$(brew --repo homebrew/services)" remote set-url origin https://e.coding.net/pkgs/homebrew/homebrew-services.git
		else
			brew tap homebrew/services https://e.coding.net/pkgs/homebrew/homebrew-services.git
		fi

		if [[ -d /usr/local/Homebrew/Library/Taps/homebrew/homebrew-cask-versions ]]; then
			git -C "$(brew --repo homebrew/cask-versions)" remote set-url origin https://e.coding.net/pkgs/homebrew/homebrew-cask-versions.git
		else
			brew tap homebrew/cask-versions https://e.coding.net/pkgs/homebrew/homebrew-cask-versions.git
		fi

		if [[ -d /usr/local/Homebrew/Library/Taps/homebrew/homebrew-cask-drivers ]]; then
			git -C "$(brew --repo homebrew/cask-drivers)" remote set-url origin https://e.coding.net/pkgs/homebrew/homebrew-cask-drivers.git
		else
			brew tap homebrew/cask-drivers https://e.coding.net/pkgs/homebrew/homebrew-cask-drivers.git
		fi

		if [[ -d /usr/local/Homebrew/Library/Taps/homebrew/homebrew-cask-fonts ]]; then
			git -C "$(brew --repo homebrew/cask-fonts)" remote set-url origin https://e.coding.net/pkgs/homebrew/homebrew-cask-fonts.git
		else
			brew tap homebrew/cask-fonts https://e.coding.net/pkgs/homebrew/homebrew-cask-fonts.git
		fi
    	# git branch --set-upstream-to=origin/master master

    	# Remove a formula and its unused dependencies
    	brew tap beeftornado/rmtree

	fi
}

# 安装 clash
_install_clash()
{
	cd ~/.bin
	case "$(uname -s)" in
		Darwin )
			_fetch https://cloudflying.coding.net/p/storage/d/mirrors/git/raw/master/pkgs/clash-darwin-amd64-v1.8.0 clash
			;;
		Linux)
			_fetch https://cloudflying.coding.net/p/storage/d/mirrors/git/raw/master/pkgs/clash-linux-amd64-v1.8.0 clash
			;;
		* )
			echo "Unknown Platform $(uname -s),please manual install, via https://github.com/Dreamacro/clash/releases"
			exit 1
	esac
}

# Conside
# moreutils parallel gnupg2 tor-browser
# gron Make JSON greppable
# tor Anonymizing overlay network for TCP 
# pass password manage
# ripgrep ripgrep recursively searches directories for a regex pattern while respecting your gitignore pass
# brew install mas mosh fzf mtr nmap openssl shellcheck tor tmux tcptraceroute repgrep ccat
# brew install node@14 php@73 tree pstree whois jq screen neofetch screenfetch htop gron
# compress
# brew install zstd unar unzip xz unrar 

_init_pkgs()
{
	if [[ "$(uname -s)" == 'Linux' ]]; then
		apt-get install neovim python3-venv python3-pip tree jq git fzf
	elif [[ "$(uname -s)" == 'Darwin' ]]; then
		# System Depency
		brew install coreutils
		# vnc-viewer telnet
		brew install neovim git python autoconf automake cmake iterm2
		brew install fd td exa ghq hub gh

		# File Content View
		brew install ccat bat mdcat

		# gron Make JSON greppable!
		brew install jq ccat gron exa ctop grex fd sd bat xsv gojq jo
		
		# Tools
		# grc Colorize logfiles and command output
		# fortune show quotes
		brew install cowsay grc fortune

		# ntfs
		# brew install mounty

		# Media
		brew install iina qqplayer qqmusic
		# input
		brew install sogouinput
		# File
		brew install fzf
		# Network Tools
		brew install clash whois
		# Chat
		brew install telegram wechat qq
		# install fonts
		brew install font-fontawesome font-hack-nerd-font
		# duti Select default apps for documents and URL schemes on macOS
		# mas macos app store interface
		brew install duti mas
		# Downloader
		brew install free-download-manager aria2
		# Programming language
		brew install php@7.4 go
		# Options
		# brew install swift ruby@2.7 rust kotlin node@16
		# brew install --cask dotnet dotnet-sdk
		# Programming language Tools
		brew install composer
		# Editor
		brew install visual-studio-code sublime-text android-studio
		# Web Browser
		brew install google-chrome firefox-developer-edition
		# Android Tools
		brew install android-platform-tools
		# Terminal
		brew install iterm2

		brew tap moncho/dry
		brew install dry


		# Fabulously kill processes. Cross-platform
		npm install -g fkill-cli
		npm install -g fx
		npm install -g nali-cli

		# Markdown
		brew install mdv mdp

		# Version Control
		brew install gh git svn git-svn

		brew install httpstat
		go install github.com/davecheney/httpstat@latest
		go install github.com/MichaelMure/mdr@latest
		go install github.com/itchyny/gojo/cmd/gojo@latest
		go install github.com/liamg/extrude/cmd/extrude@latest
		go install github.com/liamg/scout/cmd/scout@latest
		go install github.com/liamg/gifwrap/cmd/gifwrap@latest
		go install github.com/aquasecurity/tfsec/cmd/tfsec@latest
		go install github.com/aquasecurity/tfsec/cmd/tfsec-skeleton@latest
		go install github.com/aquasecurity/tfsec/cmd/tfsec-pr-lint@latest
		go install github.com/aquasecurity/tfsec/cmd/tfsec-docs@latest
		go install github.com/aquasecurity/tfsec/cmd/tfsec-checkgen@latest
		go install github.com/aquasecurity/trivy/cmd/trivy@latest
		go install github.com/acarl005/ls-go@latest
		go install github.com/jaytaylor/html2text/cmd/html2text@latest
		if [[ "$(uname -s)" == 'Linux' ]]; then
			go install github.com/liamg/traitor/cmd/traitor@latest
		fi

		# 
		brew install procs
		cargo install gip
		cargo install git-skel
	fi

	if [[ -n "$(command -v pip)" ]]; then
		pip install pynvim psutil pip-search
		pip install protobuf msgpack requests
	fi
}

_install_debian()
{
	apt install -y --no-install-recommends fortune-mod fortunes fortunes-zh
}


# Setup oh-my-zsh theme and plugin
_config_ohmyzsh()
{
	if [[ ! -d ~/.oh-my-zsh ]]; then
		git clone --depth 1 https://e.coding.net/pkgs/oh-my-zsh/oh-my-zsh.git ~/.oh-my-zsh
	else
		git -C ~/.oh-my-zsh pull
	fi

	# 恢复
	if [[ -f ~/.zshrc ]]; then
		mv ~/.zshrc ${BAK_DIR}/conf/.zshrc-${DATEFORMAT}
		ln -sf ~/.boxs/conf/.zshrc ~/.zshrc
	else
		# 若不存在则创建软连接
		ln -sf ~/.boxs/conf/.zshrc ~/.zshrc
	fi

	if [[ -d ~/.oh-my-zsh ]]; then
		mkdir -p ~/.boxs/opt
		# zplug zsh plugin manager
		if [[ ! -d ~/.boxs/opt/zplug ]]; then
			git clone --depth 1 https://github.com/zplug/zplug ~/.boxs/opt/zplug
		fi

		# Plugin

		# wget https://github.com/unixorn/warhol.plugin.zsh/raw/master/warhol.plugin.zsh
		# wget https://github.com/molovo/tipz/raw/master/tipz.zsh
		# wget https://github.com/zpm-zsh/colors/raw/master/colors.plugin.zsh
		# wget https://github.com/gretzky/auto-color-ls/raw/master/auto-color-ls.plugin.zsh
		# wget https://github.com/alejandromume/ubunly-zsh-theme/raw/main/ubunly.zsh-theme
		# https://github.com/iDoTron/tron-zsh-theme/raw/main/tron.zsh-theme
		# https://github.com/tjquillan/p9k-theme-pastel/raw/master/p9k-theme-pastel.plugin.zsh
		# https://github.com/joselpadronc/OhMyPC/raw/master/OhMyPC.zsh-theme
	fi
}

_init_nvim()
{
	if [[ -n "$(command -v nvim)" ]]; then
		if [[ ! - ~/.config/nvim ]]; then
			ln -sf ~/.boxs/conf/nvim ~/.config/nvim
		fi
	fi
}
_init_vscode()
{
	# Install VSCode extension
	# if [[ -d '/Applications/Visual\ Studio\ Code.app' ]]; then
	if [[ -d '/Applications/Visual Studio Code.app' ]]; then
		echo "Install Vscode extension"
		[ ! -f ~/.boxs/conf/backup/vscode-extensions.txt ] && echo "Not Found VSCode Extension backup" && return 0
		for ext in $(cat ~/.boxs/conf/backup/vscode-extensions.txt); do
			if [[ -z "$(ls -l ~/.vscode/extensions | grep "$ext")" ]]; then
				/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code --install-extension $ext
			else
				echo 'extension' $ext 'exist'
			fi
		done
	fi
}

_config_pkg_source()
{
	# Composer
	# Offcial
	# https://repo.packagist.org
	# https://mirrors.cloud.tencent.com/composer/
	# https://mirrors.aliyun.com/composer/
	if [[ -n "$(command -v composer)" ]]; then
		composer config -g repos.packagist composer https://pkgs-composer.pkg.coding.net/storage/composer
	fi

	# Python pip
	# Offcial
	# https://pypi.org/simple/
	# https://mirrors.bfsu.edu.cn/pypi/
	# https://pypi.tuna.tsinghua.edu.cn/simple
	# http://mirrors.cloud.tencent.com/pypi/simple/
	# https://mirrors.aliyun.com/pypi/simple/
	if [[ -n "$(command -v pip)" ]]; then
		pip config set global.index-url https://pkgs-pypi.pkg.coding.net/storage/pypi/simple
		pip config set install.trusted-host pkgs-pypi.pkg.coding.net
	fi

	if [[ -n "$(command -v pip2)" ]]; then
		pip2 config set global.index-url https://pkgs-pypi.pkg.coding.net/storage/pypi/simple
		pip2 config set install.trusted-host pkgs-pypi.pkg.coding.net
	fi

	if [[ -n "$(command -v pip3)" ]]; then
		pip3 config set global.index-url https://pkgs-pypi.pkg.coding.net/storage/pypi/simple
		pip3 config set install.trusted-host pkgs-pypi.pkg.coding.net
	fi

	# Offcial
	# https://registry.npmjs.org/
	# http://mirrors.cloud.tencent.com/npm/
	# https://registry.npmmirror.com/
	# https://r.cnpmjs.org
	if [[ -n "$(command -v npm)" ]]; then
		npm config set registry https://pkgs-npm.pkg.coding.net/storage/npm
	fi

	# Docker
	# https://pkgs-docker.pkg.coding.net/storage/docker

	if [[ -n "$(command -v gem)" ]]; then
		gem sources --remove https://rubygems.org/
		gem sources -a https://mirrors.aliyun.com/rubygems/
	fi

}

_config_sublime()
{
	if [[ "$(uname -s)" == 'Darwin' ]]; then
		if [[ -d ~/Library/Application\ Support/Sublime\ Text\ 3/ ]]; then
			_SUBL_DIR=~/Library/Application\ Support/Sublime\ Text\ 3/
		elif [[ -d ~/Library/Application\ Support/Sublime\ Text\ 4/ ]]; then
			_SUBL_DIR=~/Library/Application\ Support/Sublime\ Text\ 4/
		elif [[ -d ~/Library/Application\ Support/Sublime\ Text\ Dev/ ]]; then
			_SUBL_DIR=~/Library/Application\ Support/Sublime\ Text\ Dev/
		elif [[ -d ~/Library/Application\ Support/Sublime\ Text/ ]]; then
			_SUBL_DIR=~/Library/Application\ Support/Sublime\ Text/Packages/User/
		else
			echo "Can't find Sublime Text in your computer"
		fi
		if [[ -f ~/.boxs/conf/backup/sublimetext/License.sublime_license-mac-$(sle -v | awk -F ' ' '{print $4}' | cut -c 1-2) ]]; then
			cp ~/.boxs/conf/backup/sublimetext/License.sublime_license-mac-$(sle -v | awk -F ' ' '{print $4}' | cut -c 1-2) ${_SUBL_DIR}/Local/License.sublime_license
		fi
		cp -fr ~/.boxs/conf/backup/sublimetext/conf/ "${_SUBL_DIR}/Packages/User/"
	fi
}

# 设置 Docker 环境 并修改 普通用户使用 Docker
set_docker()
{
	if [[ "$(uname -s)" == 'Darwin' ]]; then
		CONFIG <<<"{"builder":{"gc":{"defaultKeepStorage":"64GB","enabled":true}},"experimental":true,"features":{"buildkit":true},"registry-mirrors":["https://22bvsrc3.mirror.aliyuncs.com"]}"
		mkdir -p ~/.docker
		echo ${CONFIG} > ~/docker/daemon.json
	elif [[ "$(uname -s)" == 'Linux' ]]; then
		CONFIG="{\"registry-mirrors\": [\"https://22bvsrc3.mirror.aliyuncs.com\"]}"
		echo ${CONFIG} | sudo -u root tee > /etc/docker/daemon.json
		sudo usermod -aG docker `whoami`
		sudo chmod 777 /var/run/docker.sock
		sudo systemctl restart docker
	fi
}

# Command-line DNS Client for Humans. Written in Golang
_install_doggo()
{
	mkdir -p /tmp/boxs-temp
	if [[ "$(uname -s)" == 'Darwin' ]]; then
		curl -sL https://github.com/mr-karan/doggo/releases/download/v0.4.1/doggo_0.4.1_darwin_amd64.tar.gz | tar -C /tmp/boxs-temp -xv -
		mv /tmp/boxs-temp/doggo ~/.boxs/bin/macos/
		mv /tmp/boxs-temp/doggo-api.bin ~/.boxs/bin/macos/doggo-api
	elif [[ "$(uname -s)" == 'Linux' ]]; then
		curl -sL https://github.com/mr-karan/doggo/releases/download/v0.4.1/doggo_0.4.1_linux_amd64.tar.gz | tar -C /tmp/boxs-temp -xv -
		mv /tmp/boxs-temp/doggo ~/.boxs/bin/linux/
		mv /tmp/boxs-temp/doggo-api.bin ~/.boxs/bin/linux/doggo-api
	fi
	rm -fr /tmp/boxs-temp
}

_install_nali_go()
{
	mkdir -p /tmp/boxs-temp
	cd /tmp/boxs-temp
	if [[ "$(uname -s)" == 'Darwin' ]]; then
		wget -c --no-check-certificate https://github.com/Mikubill/nali-go/releases/download/1.5.0/nali-go-darwin-amd64.zip
		unzip nali-go-darwin-amd64.zip && mv nali ~/.boxs/bin/macos/nali-go
	elif [[ "$(uname -s)" == 'Linux' ]]; then
		wget -c --no-check-certificate https://github.com/Mikubill/nali-go/releases/download/1.5.0/nali-go-linux-amd64.zip
		unzip nali-go-linux-amd64.zip && mv /tmp/boxs-temp/nali ~/.boxs/bin/linux/nali-go
	fi
	rm -fr /tmp/boxs-temp
}

_fetch_fonts()
{
	https://github.com/adobe-fonts/source-code-pro/raw/release/TTF/SourceCodePro-Medium.ttf
	https://github.com/adobe-fonts/source-code-pro/raw/release/TTF/SourceCodePro-Regular.ttf
	https://github.com/adobe-fonts/source-sans/raw/release/TTF/SourceSans3-Regular.ttf
	https://github.com/adobe-fonts/source-sans/raw/release/TTF/SourceSans3-Semibold.ttf
	https://github.com/adobe-fonts/source-serif/raw/release/TTF/SourceSerif4Subhead-Semibold.ttf
	https://github.com/adobe-fonts/source-han-mono/raw/master/Regular/OTC/SourceHanMono-Regular.otf
	https://github.com/adobe-fonts/source-han-mono/raw/master/Medium/OTC/SourceHanMono-Medium.otf
	https://fonts.google.com/download?family=Fira%20Code
	https://download.jetbrains.com/fonts/JetBrainsMono-2.242.zip
	https://github.com/adobe-fonts/source-han-serif/releases/download/2.000R/SourceHanSerifCN.zip
	https://github.com/adobe-fonts/source-han-sans/releases/download/2.004R/SourceHanSansCN.zip
	https://github.com/adobe-fonts/source-serif/raw/release/TTF/SourceSerif4-Regular.ttf
	https://github.com/adobe-fonts/source-serif/raw/release/TTF/SourceSerif4Subhead-Semibold.ttf
	# Ubuntu Mono
	https://fonts.google.com/download?family=Ubuntu%20Mono
}

_config_fonts()
{
	cp -fr ~/.boxs/conf/fonts ~/Library/Fonts
}
_set_git_config()
{
	git config --global core.pager delta
	git config --global interactive.diffFilter 'delta --color-only --features=interactive'
	git config --global core.fileMode false
}

# 获取 command-not-found 命令字典
_fetch_command_not_found_dict()
{
    echo '==> Fetch command-not-found dict'

    # macos 需要下载字典 brew 慢的雅痞
    # archlinux 本地查询速度很快无需创建数据库
    if [[ "$(uname -s)" == 'Darwin' ]]; then
        curl -sL https://github.com/Homebrew/homebrew-command-not-found/raw/master/executables.txt --output ~/.boxs/etc/command-not-found/dict.txt    
    elif [[ "$(uname -s)" == 'Linux' ]]; then
        if [[ -f /etc/os-release ]]; then
            OSNAME=$(grep '^ID=' /etc/os-release | grep '^ID=' | awk =F '=' '{print $2}')
            case "$OSNAME" in
                alpine)
                    apk list  > ~/.boxs/etc/command-not-found/dict.txt
                    ;;
                ubuntu|debian|deepin|uos|linuxmint|ubuntukylin)
                    apt list > ~/.boxs/etc/command-not-found/dict.txt
                    ;;
                arch|manjaro)
                    pacman -Sl | awk -F ' ' '{print $2}' > ~/.boxs/etc/command-not-found/dict.txt
                    ;;
                *) 
                    echo echo "unsupport your os ${OSNAME}"
                    ;;
            esac      
        fi
    fi
}

# https://github.com/sivel/speedtest-cli
_fetch_speedtest_cli()
{
    echo '==> Fetch speedtest-cli'
    if [[ -z "$(command -v speedtest-cli)" ]]; then
        curl -sL https://github.com/sivel/speedtest-cli/raw/master/speedtest.py --output ~/.boxs/bin/all/speedtest-cli
    fi

    SPEEDTEST_CLI_VER=$(speedtest-cli --version | grep 'speedtest-cli' | awk -F ' ' '{print $2}')
    LATEST_VER=$(curl -sL https://github.com/sivel/speedtest-cli/raw/master/speedtest.py | grep '^__version__' | awk -F "'" '{print $2}')
    if [[ "${SPEEDTEST_CLI_VER}" != "${LATEST_VER}" ]]; then
        echo "latest ver is ${LATEST_VER} upgrade now"
        curl -sL https://github.com/sivel/speedtest-cli/raw/master/speedtest.py --output ~/.boxs/bin/all/speedtest-cli
    else
        echo "speedtest-cli v${SPEEDTEST_CLI_VER} is latest version"
    fi
}

# 获取可执行文件
_fetch_script_bin()
{
    echo "==> Fetch neofetch"
    curl -sL https://github.com/dylanaraps/neofetch/raw/master/neofetch             --output ~/.boxs/bin/all/neofetch

    echo "==> Fetch screenfetch"
    curl -sL https://github.com/KittyKatt/screenFetch/raw/master/screenfetch-dev    --output ~/.boxs/bin/all/screenfetch

    echo "==> Fetch speedtest-cli"
    curl -sL https://github.com/sivel/speedtest-cli/raw/master/speedtest.py         --output ~/.boxs/bin/all/speedtest-cli

    echo "==> Fetch bashtop"
    curl -sL https://github.com/aristocratos/bashtop/raw/master/bashtop --output ~/.boxs/bin/all/bashtop

    # bashtop depens
    pip3 install psutil 2>1 > /dev/null

    delta_latest_ver=$(curl -sL https://api.github.com/repos/dandavison/delta/releases/latest | jq .tag_name | awk -F '"' '{print $2}')
    # ookla speedtest.net cli speed test
    if [[ "$(uname -s)" == 'Darwin' ]]; then
        echo "==> Fetch speedtest.net speedtest for macos"
        curl -sL https://install.speedtest.net/app/cli/ookla-speedtest-1.1.1-macosx-x86_64.tgz | tar -C ~/.boxs/bin/macos/ -xvf - speedtest

        echo "==> Fetch delta for macos"
        # wget -c --content-disposition --no-check-certificate https://github.com/dandavison/delta/releases/download/${delta_latest_ver}/delta-${delta_latest_ver}-x86_64-apple-darwin.tar.gz -O /tmp/delta-${delta_latest_ver}-x86_64-apple-darwin.tar.gz
        curl -sL https://github.com/dandavison/delta/releases/download/${delta_latest_ver}/delta-${delta_latest_ver}-x86_64-apple-darwin.tar.gz | tar -C /tmp/ -xzvf -
        mv /tmp/delta-${delta_latest_ver}-x86_64-apple-darwin/delta ~/.boxs/bin/macos && rm -fr /tmp/delta-*
    elif [[ "$(uname -s)" == 'Linux' ]]; then
        OSNAME=$(grep '^ID=' /etc/os-release | grep '^ID=' | awk =F '=' '{print $2}')

        # alpine 使用 musl 标准库 某些基于 gnu 编译的程序无法使用
        # alpine 解压须使用 gnu tar 自带 tar 不支持管道
        # apk add --no-cache tar
        if [[ "${OSNAME}" == 'alpine' ]]; then
            echo "==> Fetch delta for standard linux"
            curl -sL https://github.com/dandavison/delta/releases/download/${delta_latest_ver}/delta-${delta_latest_ver}-x86_64-unknown-linux-musl.tar.gz | tar -C /tmp -xzvf -
            mv /tmp/delta-${delta_latest_ver}-x86_64-unknown-linux-musl/delta ~/.boxs/bin/macos && rm -fr /tmp/delta-*
        else
            echo "==> Fetch delta for alpine linux"
            curl -sL https://github.com/dandavison/delta/releases/download/${delta_latest_ver}/delta-${delta_latest_ver}-x86_64-unknown-linux-gnu.tar.gz | tar -C /tmp -xzvf -
            mv /tmp/delta-${delta_latest_ver}-x86_64-unknown-linux-gnu/delta ~/.boxs/bin/macos && rm -fr /tmp/delta-*
        fi

        echo "==> Fetch speedtest.net speedtest for linux"
        curl -sL https://install.speedtest.net/app/cli/ookla-speedtest-1.1.1-linux-x86_64.tgz | tar -C ~/.boxs/bin/macos/ -xvf - speedtest

        curl -sL https://github.com/dandavison/delta/releases/download/${delta_latest_ver}/delta-${delta_latest_ver}-x86_64-unknown-linux-gnu.tar.gz | tar -C ~/.boxs/bin/macos/ -xvf - "delta-${delta_latest_ver}-x86_64-unknown-linux-gnu/delta"
    fi
}

_config()
{
	_init_brew
	_config_fonts
	_config_ohmyzsh
	_init_nvim
	_config_sublime
	_init_vscode
	_fetch_command_not_found_dict
}

_init_check
# 设置 gitconfig
# cp $SCRIPT_DIR/gitconfig ~/.gitconfig
# read -p "Name (first and last): " gitname
# read -p "Email address: " gitemail
# sed -i "s/GITNAME/$gitname/g" ~/.gitconfig
# sed -i "s/GITEMAIL/$gitemail/g" ~/.gitconfig

# ln -s `pwd`/bashrc ~/.bashrc
# ln -s `pwd`/vimrc ~/.vimrc
# ln -s `pwd`/tmux.conf ~/.tmux.conf

# # Neovim setup
# mkdir -p ~/.config/nvim/
# rm -f ~/.config/nvim/init.vim
# ln -s ~/.vimrc ~/.config/nvim/init.vim
# _install_doggo

# _install_nali_go
# Fonts
# font dir
# ~/.fonts
# /usr/share/fonts
# /usr/local/share/fonts
# ~/.local/share/fonts
# macos
# ~/Library/Fonts
# _init_brew
# _fetch_command_not_found_dict
# _config_ohmyzsh
# _fetch_speedtest_cli
# _fetch_script_bin