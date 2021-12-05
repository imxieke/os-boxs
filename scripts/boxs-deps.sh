#!/usr/bin/env bash
###
 # @Author: Cloudflying
 # @Date: 2021-12-04 15:02:24
 # @LastEditTime: 2021-12-04 17:48:40
 # @LastEditors: Cloudflying
 # @Description: update boxs deps
 # @FilePath: /.boxs/deps.sh
### 

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