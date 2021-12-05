#!/usr/bin/env bash
###
 # @Author: Cloudflying
 # @Date: 2021-12-04 14:43:49
 # @LastEditTime: 2021-12-04 18:21:03
 # @LastEditors: Cloudflying
 # @Description: run command tips when command not found
 # @FilePath: /.boxs/scripts/command-not-found.sh
###

# TODO 
# ubuntu archlinux support

# alpine linux
_alpine_pkg_list()
{
    if [[ -z "$(ls /var/cache/apk | grep 'APKINDEX')" ]]; then
        echo 'use command-not-found need package database, run \`apk update\` first'
        exit 127
    fi
    pkgname=$(grep "^${1}" ~/.boxs/etc/command-not-found/dict.txt | sort -g | head -n 1 | awk -F "\-[0-9]." '{print $1}')
    echo $pkgname
}

# debian-like
_ubuntu_pkg_list()
{
    if [[ -z "$(ls -lha /var/lib/apt/lists/ | grep Packages)" ]]; then
        echo 'use command-not-found need package database, run \`apt update\` first'
        exit 127
    fi
    pkgname=$(grep "^${1}" ~/.boxs/etc/command-not-found/dict.txt | awk -F '/' '{print $1}' | sort -g | head -n 1)
    echo $pkgname
}

# archlinux
_archlinux_pkg_list()
{
    if [[ ! -f /var/lib/pacman/sync/core.db ]]; then
        echo 'use command-not-found need package database, run \`pacman -Syy\` first'
        exit 127
    fi
    pkgname=$(grep "^${1}" ~/.boxs/etc/command-not-found/dict.txt | awk -F '/' '{print $1}' | sort -g | head -n 1)
    echo $pkgname
}

_brew_pkg_list()
{
    if [[ ! -f ~/.boxs/etc/command-not-found/dict.txt ]]; then
        echo 'use command-not-found need package database, run \`~/.boxs/scripts/boxs-deps.sh\` first'
        exit 127
    fi
    pkgname=$(grep "^${1}" ~/.boxs/etc/command-not-found/dict.txt | sort -g | head -n 1 | awk -F '\(' '{print $1}')
    echo $pkgname
}
shell_command_not_found_handle() {

    local cmd="$1"
    local dict=~/.boxs/etc/command-not-found/dict.txt

    if [[ -z "$(command -v ${cmd})" ]]; then
        if [[ "$(uname -s)" == 'Darwin' ]]; then
            pkgs=$(_brew_pkg_list $cmd)
        elif [[ "$(uname -s)" == 'Linux' ]]; then
            OSNAME=$(grep '^ID=' /etc/os-release | grep '^ID=' | awk -F '=' '{print $2}')
            case "${OSNAME}" in
                alpine) pkgs=(_alpine_pkg_list $cmd)
                ;;
                ubuntu|debian|deepin|uos|linuxmint|ubuntukylin) pkgs=$(_ubuntu_pkg_list $cmd)
                ;;
                arch|manjaro) pkgs=$(_archlinux_pkg_list $cmd)
                ;;
            esac
        fi

        if [[ -n "${pkgs}" ]]; then
            echo "did you mean: $pkgs ? \n"
            echo "The program '${pkgs}' is currently not installed. You can install it by typing:"
            if [[ "$(uname -s)" == 'Darwin' ]]; then
                echo "          brew install $pkgs "
            elif [[ "$(uname -s)" == 'Linux' ]]; then
                OSNAME=$(grep '^ID=' /etc/os-release | grep '^ID=' | awk -F '=' '{print $2}')
                case "${OSNAME}" in
                    alpine) echo "apk install ${pkgs}"
                    ;;
                    ubuntu|debian|deepin|uos|linuxmint|ubuntukylin) echo "apt install ${pkgs}"
                    ;;
                    arch|manjaro) echo "pacman -S ${pkgs}"
                    ;;
                esac  
            fi
        else
            echo "command not found: $cmd"
        fi
    fi
}

if [ -n "$BASH_VERSION" ]; then
    command_not_found_handle() {
        shell_command_not_found_handle $*
        return $?
    }
elif [ -n "$ZSH_VERSION" ]; then
    command_not_found_handler() {
        shell_command_not_found_handle $*
        return $?
    }
fi