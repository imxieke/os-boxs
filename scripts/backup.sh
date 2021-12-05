#!/usr/bin/env bash

# Rsync 过滤目录不支持设置绝对目录 不然过滤规则无效 过滤文件需要切换路径至文件路径 否则不生效 目录可以在 上一级设置 dir/ignore_dir
# rsync -avz 将不同的文件同步过来 已存在但本地更改的会被覆盖
# macos linux 目录仅区分不同的配置文件 相同的会放在 common

USER_HOME=${HOME}
GIT_DIR=$(pwd)
DATA_DIR=${GIT_DIR}
GENDATA=${DATA_DIR}/conf
LOGFILE=${GIT_DIR}/logs/backup.log
RSYNC_CMD='rsync -avz'
OS=$(uname -s)

if [[ ${OS} == 'Darwin' ]]; then
	BAKTO=${DATA_DIR}/macos
elif [[ ${OS} == 'Linux' ]]; then
	BAKTO=${DATA_DIR}/linux
else
	exit 1
fi

BAKTO=${DATA_DIR}/conf

# 记录日志时间
logger()
{
	echo "" >>${LOGFILE}
	echo $(date) >> ${LOGFILE}
	echo "" >>${LOGFILE}
}

rsync_config()
{
	cd ${USER_HOME}

	# Composer 
	if [[ -f ${USER_HOME}/.composer/config.json ]]; then
		echo "Composer Syncing"
		logger
		${RSYNC_CMD} --exclude="cache**" --exclude="*/.htaccess" .composer ${GENDATA} >> ${LOGFILE}
	fi

	# ohmyzsh config file
	if [[ -f ${USER_HOME}/.zshrc ]]; then
		echo "zshrc Syncing"
		logger
		# ${RSYNC_CMD} .zshrc ${GENDATA} >> ${LOGFILE}
	fi

	# ohmyzsh plugins
	if [[ -d ${USER_HOME}/.oh-my-zsh/plugins ]]; then
		echo "zsh plugins Syncing"
		logger
		# ${RSYNC_CMD} .oh-my-zsh/plugins ${GENDATA}/oh-my-zsh >> ${LOGFILE}
	fi

	# ohmyzsh themes
	if [[ -d ${USER_HOME}/.oh-my-zsh/themes ]]; then
		echo "zsh themes Syncing"
		logger
		# ${RSYNC_CMD} .oh-my-zsh/themes ${GENDATA}/oh-my-zsh >> ${LOGFILE}
	fi

	# npm
	if [[ -f ${USER_HOME}/.npmrc ]]; then
		echo "npmrc Syncing"
		logger
		${RSYNC_CMD} .npmrc ${GENDATA} >> ${LOGFILE}
	fi

	# ruby gem
	if [[ -f ${USER_HOME}/.gemrc ]]; then
		echo "gemrc Syncing"
		logger
		${RSYNC_CMD} .gemrc ${GENDATA} >> ${LOGFILE}
	fi

	# Git
	if [[ -f ${USER_HOME}/.gitconfig ]]; then
		echo "Git Config Syncing, Backup it"
		logger
		${RSYNC_CMD} .gitconfig ${GENDATA} >> ${LOGFILE}
	fi

	# Python pip
	if [[ -f ${USER_HOME}/.pip/pip.conf ]]; then
		echo "Pip Syncing"
		logger
		${RSYNC_CMD} .pip ${GENDATA} >> ${LOGFILE}
	fi

	# Docker
	# if [[ -f ${USER_HOME}/.docker/daemon.json ]]; then
		# echo "Docker Syncing"
		# logger
		# mkdir -p ${GENDATA}/.docker
		# ${RSYNC_CMD} .docker/daemon.json ${GENDATA}/.docker >> ${LOGFILE}
	# fi

	if [[ -d ${USER_HOME}/.config/clash ]]; then
		echo "Clash Syncing"
		logger
		${RSYNC_CMD} ${USER_HOME}/.config/clash ${BAKTO} >> ${LOGFILE}
	fi

	# vscode extensions file is very large
	# if [[ -d ${USER_HOME}/.vscode/extensions ]]; then
		# echo "vscode extensions Syncing"
		# cd ${USER_HOME}/.vscode/extensions/
		# logger
		# ${RSYNC_CMD} --exclude .obsolete . ${GENDATA}/vscode/extensions >> ${LOGFILE}
	# fi

}

sync_other()
{
	# fonts
	if [[ -d ${USER_HOME}/Library/Fonts ]]; then
		echo "Scanner fonts"
		logger
		cd ${USER_HOME}/Library/Fonts
		${RSYNC_CMD} --exclude encodings.dir --exclude fonts.dir --exclude fonts.list --exclude fonts.scale . ${GENDATA}/fonts >> ${LOGFILE}
	fi
}

rsync_bin()
{
	cd ${USER_HOME}
	# BestTrace for macOS
	if [[ -f ${USER_HOME}/.bin/besttracemac ]]; then
		echo "BestTrace for macOS Syncing"
		logger
		${RSYNC_CMD} .bin/besttracemac ${BAKTO}/bin >> ${LOGFILE}
	fi

	# BestTrace for macOS
	if [[ -f ${USER_HOME}/.bin/besttrace ]]; then
		echo "BestTrace for macOS Syncing"
		logger
		${RSYNC_CMD} .bin/besttrace ${BAKTO}/bin >> ${LOGFILE}
	fi

}

rsync_config
sync_other
rsync_bin
