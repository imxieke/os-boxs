## Boxs system toolset boxs
### Support OS
- linux
- macos

### Tools
- vim
- oh-my-zsh
- besttrace
- autossh

## TOOD
- 自动加载当前目录下的 .env 文件 将程序的配置文件加载到系统内
- 终端发送通知

## Path Struct
- etc 配置文件目录
- bin 二进制文件目录
     - all   通用 二进制文件 如 Shell 脚本
     - macos macOS 二进制文件目录
     - linux linux amd64 系统二进制文件

- scripts 平时会用到的脚本库(非可直接执行)
- sites Web 应用
- etc
    - file-tpl 创建文件使用的模板
    - autossh autossh 配置文件
- opt like unix opt directory
    
## Application
- doggo DNS Client for Humans
- pst TUI process monitor written in Go
- gkill Interactice process killer for Linux and macOS
- fkill Fabulously kill processes. Cross-platform
- exa A modern replacement for ‘ls’.
- fx Command-line tool and terminal JSON viewer
- dry - A Docker manager for the terminal
- ctop Top-like interface for container metrics
- grex Command-line tool for generating regular expressions
- fd Simple, fast and user-friendly alternative to find
- sd Intuitive find & replace CLI (sed alternative)
- bat A cat(1) clone with wings.
- xsv A fast CSV command line toolkit written in Rust.
- mdv Styled terminal markdown viewer
- mdp A command-line based markdown presentation tool.
- git-skel A git subcommand to apply skeleton repository continuously
- procs A modern replacement for ps written in Rust
- gojq Pure Go implementation of jq
- jo JSON output from a shell
- gojo like jo
- scout 🔭 Lightweight URL fuzzer and spider: Discover a web server's undisclosed files, directories and VHOSTs
- traitor Automatic Linux privesc via exploitation of low-hanging fruit e.g. gtfobins, polkit, docker socket
- gifwrap GIFs in your terminal
- trivy Scanner for vulnerabilities in container images, file systems, and Git repositories, as well as for configuration issues


## fonts
- https://github.com/ryanoasis/nerd-fonts
- https://design.ubuntu.com/font/


## Repository /etc/apt/sources.list.d
```
deb [by-hash=force] http://packages.deepin.com/deepin panda main contrib non-free
deb https://mirrors.ustc.edu.cn/deepin panda main contrib non-free
# deb-src http://packages.deepin.com/deepin panda main contrib non-free

deb https://mirrors.ustc.edu.cn/kali kali-rolling main contrib non-free

deb [arch=amd64] https://download.docker.com/linux/debian jessie edge
deb-src [arch=amd64] https://download.docker.com/linux/debian jessie edge

# You may comment out this entry, but any other modifications may be lost.
deb [arch=amd64] http://packages.microsoft.com/repos/vscode stable main

deb http://repository.spotify.com stable non-free
```



alias f="fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}'"
alias x="exa -Flam --git --color-scale --icons"
~/Library/Android/sdk/emulator/emulator -avd Pixel_3a_API_R -netdelay none -netspeed full