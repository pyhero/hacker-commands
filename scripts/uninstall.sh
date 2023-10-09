#!/usr/bin/env bash
# run this on each server

# check runner
[ $(whoami) != 'root' ] && echo "run as root" && exit 2

BASE_DIR="$(cd "`dirname $0`" && echo $PWD || exit 2)"

# import HACKER conf
source ${BASE_DIR}/../conf/env_sets

HACKER_USER_HOME_DIR=$(sudo -u ${HACKER_USER} -i echo \$HOME)
[ -z ${HACKER_USER_HOME_DIR} ] && echo "get ${HACKER_USER}'s home directory failed" && exit 2
HACKER_USER_BIN_DIR="${HACKER_USER_HOME_DIR}/bin"

# uninstall bin
for bin in $(/bin/ls ${BASE_DIR}/../bin);do
    BIN_FILE="${HACKER_USER_BIN_DIR}/${bin}"

    if [ -f ${BIN_FILE} ];then
        echo "rm [${BIN_FILE}]"
        rm ${BIN_FILE}
    fi
done

# uninstall HACKER env conf
hacker_env="${HACKER_USER_BIN_DIR}/env_sets"

if [ -f ${hacker_env} ];then
    echo "rm [${hacker_env}]"
    rm ${hacker_env}
fi

# uninstall sudo
sudo_file="/etc/sudoers.d/${HACKER_USER}"

if [ -f ${sudo_file} ];then
    echo "rm [${sudo_file}]"
    rm ${sudo_file}
fi

# unistall program
PROGRAM_DIR="${HACKER_PROGRAM_DIR}/hacker-commands"

if [ -e ${PROGRAM_DIR} ];then
    echo "rm -r [${PROGRAM_DIR}]"
    rm -r ${PROGRAM_DIR}
fi

echo "uninstall done"
