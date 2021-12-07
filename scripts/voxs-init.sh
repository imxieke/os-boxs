#!/usr/bin/env bash

mkdir -p ~/.boxs/{backup,opt,logs}

# 初始化系统检测
_init_check()
{
	TOOLS='neovim jq curl wget axel'
}

_init_brew()
{
	if [[ -n "$(command -v brew)" ]]; then
		brew tap homebrew/cask-versions
		brew tap homebrew/command-not-found
		brew tap homebrew/cask-drivers
		brew tap homebrew/cask-fonts
		brew tap homebrew/json
	fi
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
		brew install neovim git python python3 python-pip python3-pip autoconf automake cmake telnet vnc-viewer iterm2 
		brew install fd td exa ghq hub gh

		# File Content View
		brew install ccat bat mdcat

		# gron Make JSON greppable!
		brew install jq ccat gron exa ctop grex fd sd bat xsv gojq jo
		
		# Tools
		# grc Colorize logfiles and command output
		# fortune show quotes
		brew install cowsay grc fortune

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


vscode_extensions='
	ahmadalli.vscode-nginx-conf
	akamud.vscode-theme-onedark
	akamud.vscode-theme-onelight
	andischerer.theme-atom-one-dark
	asciidoctor.asciidoctor-vscode
	bierner.markdown-emoji
	bierner.markdown-mermaid
	bmalehorn.shell-syntax
	bpruitt-goddard.mermaid-markdown-syntax-highlighting
	deepinthought.vscode-shell-snippets
	deitry.apt-source-list-syntax
	dnicolson.binary-plist
	eamodio.gitlens
	editorconfig.editorconfig
	emroussel.atomize-atom-one-dark-theme
	formulahendry.auto-close-tag
	foxundermoon.shell-format
	gera2ld.markmap-vscode
	golang.go
	hangxingliu.vscode-nginx-conf-hint
	hollowtree.vue-snippets
	ivory-lab.jenkinsfile-support
	jakebathman.nginx-log-highlighter
	jeff-hykin.better-shellscript-syntax
	jiejie.lua-nginx-snippets
	johnsoncodehk.volar
	jprestidge.theme-material-theme
	juanblanco.solidity
	l13rary.l13-sh-snippets
	mikestead.dotenv
	ms-python.python
	ms-python.vscode-pylance
	ms-toolsai.jupyter
	ms-vscode-remote.remote-containers
	ms-vscode-remote.remote-ssh
	ms-vscode-remote.remote-ssh-edit
	ms-vscode-remote.vscode-remote-extensionpack
	ms-vscode.sublime-keybindings
	octref.vetur
	pkief.material-icon-theme
	randomfractalsinc.geo-data-viewer
	raynigon.nginx-formatter
	redhat.vscode-commons
	redhat.vscode-xml
	redhat.vscode-yaml
	sdras.vue-vscode-snippets
	shanoor.vscode-nginx
	shd101wyy.markdown-preview-enhanced
	stayfool.vscode-asciidoc
	steoates.autoimport
	vscode-icons-team.vscode-icons
	william-voyek.vscode-nginx
	xadillax.viml
	yzane.markdown-pdf
	yzhang.markdown-all-in-one
'

if [[ ! -d ~/.oh-my-zsh ]]; then
	git clone --depth 1 https://e.coding.net/pkgs/oh-my-zsh/oh-my-zsh.git ~/.oh-my-zsh
fi

	# Setup oh-my-zsh theme and plugin
_config_ohmyzsh()
{
	if [[ -d ~/.oh-my-zsh ]]; then
		mkdir -p ~/.boxs/opt
		# zplug zsh plugin manager
		git clone --depth 1 https://github.com/zplug/zplug ~/.boxs/opt/zplug
		# git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
		# Plugin
		# git clone --depth 1 https://github.com/zdharma-continuum/fast-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/fast-syntax-highlighting
		# git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
		# git clone --depth 1 https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions
		# git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
		# git clone --depth 1 https://github.com/zsh-users/zsh-history-substring-search ~/.oh-my-zsh/custom/plugins/zsh-history-substring-search
		# git clone --depth 1 https://github.com/supercrabtree/k ~/.oh-my-zsh/custom/plugins/k
		# git clone --depth 1 https://github.com/wfxr/formarks ~/.oh-my-zsh/custom/plugins/formarks
		# git clone --depth 1 https://github.com/Aloxaf/fzf-tab ~/.oh-my-zsh/custom/plugins/fzf-tab
		# git clone --depth 1 https://github.com/unixorn/fzf-zsh-plugin ~/.oh-my-zsh/custom/plugins/fzf-zsh-plugin
		# git clone --depth 1 https://github.com/chitoku-k/fzf-zsh-completions.git ~/.oh-my-zsh/custom/plugins/fzf-zsh-completions
		# git clone --depth 1 https://github.com/yuki-yano/fzf-preview.zsh ~/.oh-my-zsh/custom/plugins/fzf-preview
		# git clone --depth 1 https://github.com/oldratlee/hacker-quotes.git ~/.oh-my-zsh/custom/plugins/hacker-quotes
		# git clone --depth 1 https://github.com/trystan2k/zsh-tab-title ~/.oh-my-zsh/custom/plugins/zsh-tab-title
		

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

_init_vscode()
{
	# Install VSCode extension
	if [[ -d '/Applications/Visual Studio Code.app' ]]; then
		for ext in ${vscode_extensions[*]}; do
			if [[ -z "$(ls -l ~/.vscode/extensions | grep "$ext")" ]]; then
				/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code --install-extension $ext
			else
				echo 'extension' $ext 'exist'
			fi
		done
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

__set_git_config()
{
	git config --global core.pager delta
	git config --global interactive.diffFilter 'delta --color-only --features=interactive'
	git config --global core.fileMode false
}

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
_install_nali_go
# Fonts
# font dir
# ~/.fonts
# /usr/share/fonts
# /usr/local/share/fonts
# ~/.local/share/fonts
# macos
# ~/Library/Fonts

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
            case "$VAR" in
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

_fetch_command_not_found_dict
# _fetch_speedtest_cli
_fetch_script_bin