#!/usr/bin/env bash
###
 # @Author: Cloudflying
 # @Date: 2021-12-03 22:58:44
 # @LastEditTime: 2021-12-22 23:26:08
 # @LastEditors: Cloudflying
 # @Description: 
 # @FilePath: /.boxs/scripts/function.sh
### 

_red() {
    printf '\033[1;31;31m%b\033[0m' "$1"
}

_green() {
    printf '\033[1;31;32m%b\033[0m' "$1"
}

_yellow() {
    printf '\033[1;31;33m%b\033[0m' "$1"
}

_info() {
    _green "[Info] "
    printf -- "%s" "$1"
    printf "\n"
}

_warn() {
    _yellow "[Warning] "
    printf -- "%s" "$1"
    printf "\n"
}

_error() {
    _red "[Error] "
    printf -- "%s" "$1"
    printf "\n"
    exit 1
}


# Set Git Config
set_config_git(){
	USERNAME="Cloudflying" #Example Username
	MAIL="oss@live.hk"	   #Example Mail
	git config --global user.name $USERNAME
	git config --global user.email $MAIL
	echo "Set Success"
}

clash_log(){
    if [[ -f ~/.app/clash.log ]]; then
          tail -f ~/.app/clash.log
    fi
}

# Load Library

extract2() {
  local verbose test

  if [[ -n "${BASH_VERSION-}" ]]; then local fn=${FUNCNAME[0]}; else local fn=$0; fi
  local __usage__="Usage: ${fn} [-vt] file"

  local opt OPTIND=1
  while getopts ':vt' opt; do
    case ${opt} in
      v) verbose="-${opt}" ;;
      t) test="-${opt}" ;;
      *)
        echo "Unrecognized option -${OPTARG}" >&2
        echo "${__usage__}" >&2
        return 64 # EX_USAGE
        ;;
    esac
  done

  shift $((OPTIND - 1))

  if (($# == 0)); then
    echo "${__usage__}" >&2
    return 64 # EX_USAGE
  fi

  case "$1" in
    *.tgz|*.txz|*.tbz2)
      ;;
    *.tar.gz|*.tar.xz|*.tar.bz2)
      tar ${verbose} ${test:--x} -f "$1" ;;
    *.gz)
      gunzip ${verbose} ${test} "$1" ;;
    *.xz)
      xz ${verbose} ${test} -d "$1" ;;
    *.bz2)
      bunzip2 ${verbose} ${test} "$1" ;;
    *.zip)
      unzip ${verbose:--q} ${test:+-l} "$1" ;;
    *.[jwe]ar)
      jar ${test:-x}${verbose:+v}f "$1" ;;
    *.Z)
      uncompress "$1" ;;
    *.7z)
      7z x "$1" ;;
    *.safariextz)
      xar ${verbose} ${test:--x} -f "$1" ;;
    *)
      echo "Don't know how to extract '$1'" >&2;
      return 1
  esac
}

# update clash ipdb
update_clash_mmdb()
{
    cd $HOME/.config/clash
    wget https://raw.github.cnpmjs.org/Hackl0us/GeoIP2-CN/release/Country.mmdb -O Country.mmdb
    echo "Done!"
}

# file
ls-file()
{
  ls -lha $1 | grep -v "\.$" | grep "^-" | grep ''
}

# dir
ls-dir()
{
  ls -lha $1 | grep -v "\.$" | grep "^d" | grep ''
}

# symbolic link file
ls-link()
{
  ls -lha $1 | grep -v "\.$" | grep "^l" | grep ''
}

# Pipe File FIFO
ls-pine()
{
  ls -lha $1 | grep -v "\.$" | grep "^p" | grep ''
}

# Block Device File
ls-block()
{
  ls -lha $1 | grep -v "\.$" | grep "^b" | grep ''
}

# character device file
ls-char()
{
  ls -lha $1 | grep -v "\.$" | grep "^c" | grep ''
}

# Clone Git Repo and save as username-reponame format
# 输入 https://github.com/XXX/XXX 自动保存为目录 XXX-XXX
gdps()
{
  repo=$1
	[ -z "$repo" ] && echo "Type repo please" && exit 1
	save_dir=$(echo $repo | awk -F '/' '{print $4"-"$5}' | sed 's/\.git//g' )
  git clone --depth 1 $repo $save_dir $2 $3 $4
}

# Check Command Exist
_iscmd()
{
    if [[ ! -z $(command -v $1 )  ]];then
        echo 'true'
    fi
}

clash_start()
{
    if [[ -f ~/.app/clash ]]; then
        nohup ~/.app/clash >> ~/.app/clash.log &
    else
        echo -e "Clash Not Found , Install it first"
    fi
}

clash_stop(){
    PID=$(ps -ax | grep -v grep | grep clash | awk -F ' ' '{print $1}')
    if [[ -n "${PID}" ]]; then
        CMD="/usr/kill -9 ${PID}"
        # $(${CMD})
        # ${CMD}
        kill --help
        # echo ${PATH}
        # command -v kill
    else
      echo -e "Clash Not Running"
    fi
}

clash_status(){
    local PID=$(ps -ax | grep -v grep | grep clash | awk -F ' ' '{print $1}')
    if [[ -n "${PID}" ]]; then
      _info "Clash is Running PID: ${PID}"
    else
      _info "Clash Not Running"
    fi
}

clash_restart(){
    clash_stop
    clash_start
}

os_name_get()
{
  if [[ "${OSNAME}" == 'Darwin' ]]; then
    OS_NAME="macOS"
  elif [[ "${OSNAME}" == 'Linux' ]]; then
    OS_NAME="Linux"
  fi
  echo ${OS_NAME}
}

opengate()
{
  if [[ `is_mac`  == 'true' ]]; then
      echo "Opening the gates"
      sudo spctl --master-disable
      defaults write com.apple.LaunchServices LSQuarantine -bool NO
  fi
}

closegate()
{
  if [[ `is_mac`  == 'true' ]]; then
      echo "Gatekeeper re-activated"
      sudo spctl --master-enable
      defaults write com.apple.LaunchServices LSQuarantine -bool YES
  fi
}

sql()
{
  if [ -z "$(command -v mysql)" ] && echo 'mysql command not found' && exit 1
  echo "$@" | mysql -uroot -p${MYSQL_PASSWD} | grep -v 'insecure'
}

# 显示目录所有文件但不显示属性 大小权限创建日期等
ls-list()
{
    ls -lha $1 | awk -F ' ' '{print $9}' | sed '1,3d'
}

flush_dns()
{
    if [[ $OSTYPE =~ ^darwin ]]; then
      sudo killall -HUP mDNSResponder
      sudo killall mDNSResponderHelper
      sudo dscacheutil -flushcache
    else
      echo "Not implemented on ${OSTYPE} yet." >&2
    fi
}

# mkdir & cd
function mkd {
    mkdir -p "$@" && cd $_
}

# base64 解码
debase64()
{
    echo $1 | base64 -d
}

# base64 编码
enbase64()
{
    echo $1 | base64
}

function xtree {
    find ${1:-.} -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'
    find ${1:-.} -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'
}

# Size sort ls
sls()
{
    ls -lha $@ | grep -v '^total '| grep -v '\.$' |  awk -F ' ' '{print $5" "$9}' | sort --human-numeric-sort
}

# 获取程序 Bundle ID
get_appid()
{
  osascript -e "id of app \"$1\""
}

# 设置扩展默认打开程序
# 支持直接设定 App 名称或绝对路径 /Applications
set_ext_open_by()
{
  ext=$1
  app=$2
  APP_REAL_NAME=''
  if [[ -d "$2" ]]; then
    APP_REAL_NAME=$(echo "$2" | awk -F '/' '{print $3}' | awk -F '.' '{print $1}')
  fi
  appid=$(get_appid "$APP_REAL_NAME")
  duti -s "${appid}" "${ext}" all
  echo "completed set ext: ${ext} open by ${appid}"
}

urlencode()
{
  php -r "echo urlencode("$1").PHP_EOL;"
}

urldecode()
{
  php -r "echo urldecode("$1").PHP_EOL;"
}

git-pulls()
{
    dir=$(cd $1;pwd)
    echo $dir
    for i in $(ls $dir)
    do
        i=${dir}/${i}
        if [[ -f "${i}/.git/config" ]]; then
            echo $i
            cd $i
            echo "Pull from: " $(grep 'url' .git/config  | awk -F '=' '{print $2}')
            git pull
            cd ..
        fi
    done
}

function crypt() {
    openssl des3 -in "$1" -out "$2"
}

function decrypt() {
    openssl des3 -d -in "$1" -out "$2"
}

# Find dictionary definition
dict() {
    if [ "$3" ]; then
        curl "dict://dict.org/d:$1 $2 $3"
    elif [ "$2" ]; then
        curl "dict://dict.org/d:$1 $2"
    else
        curl "dict://dict.org/d:$1"
    fi
}

# Find geo info from IP
ipgeo() {
    # Specify ip or your ip will be used
    if [ "$1" ]; then
        curl "http://api.db-ip.com/v2/free/$1"
    else
        curl "http://api.db-ip.com/v2/free/$(myip)"
    fi
}

# Show covid-19 spread stats
corona() {
    # Specify country otherwise shows stats for all
    if [ "$1" ]; then
        curl "https://corona-stats.online/$1"
    else
        curl "https://corona-stats.online"
    fi
}

function mkd()  {
	mkdir -p -- "$@" && cd -- "$@"
}

show_terminal_colors() {
  for i in {0..255} ; do
    printf "\x1b[38;5;${i}mcolor${i}\n"
  done
}

pong() {
  /sbin/ping -c 10 "$@"
}

function hexpass() {
  openssl rand -hex 24 $@
}

server() {
  if [[ "$1" == "http" ]]; then
    python -m SimpleHTTPServer $2
    
  elif [[ "$1" == "https" ]]; then
    python -m SimpleHTTPSServer $2  
  fi
}

# 强制将所有输出的数据重定向至黑洞
void_exec()
{
	$@ 2>1 > /dev/null
}

# View infomation
function vif()
{
	case "$1" in
		*.gpg)
			gpg --quiet --batch -d $@
			;;
		*.html|html5|htm)
			bat --style='numbers' -l html $@
			;;
		*.css)
			bat --style='numbers' -l css $@
			;;
		*.js)
			bat --style='numbers' -l javascript $@
			;;
		*.json)
			bat --style='numbers' -l json $@
			;;
		*.c)
			bat --style='numbers' -l c $@
			;;
		*.cpp)
			bat --style='numbers' -l cpp $@
			;;
		*.js)
			bat --style='numbers' -l javascript $@
			;;
		*.js)
			bat --style='numbers' -l javascript $@
			;;
		*)
			bat --style='numbers' $@
			;;
	esac	
}