#!/usr/bin/env bash
# run this on each server

# check runner
[ $(whoami) != 'root' ] && echo "run as root" && exit 2

BASE_DIR="$(cd "`dirname $0`" && echo $PWD || exit 2)"

# import HACKER conf
source ${BASE_DIR}/../conf/env_sets

PROGRAM_DIR="${HACKER_PROGRAM_DIR}/hacker-commands"

HACKER_USER_HOME_DIR=$(sudo -u ${HACKER_USER} -i echo \$HOME)
[ -z ${HACKER_USER_HOME_DIR} ] && echo "get ${HACKER_USER}'s home directory failed" && exit 2
HACKER_USER_BIN_DIR="${HACKER_USER_HOME_DIR}/bin"

# check dir
if ! echo ${BASE_DIR} | grep -q "^${PROGRAM_DIR}";then
    echo "run [mv ${BASE_DIR}/../../hacker-commands ${PROGRAM_DIR}]"
    exit 2
fi

# init hacker user
# 1. init sudo
/bin/bash ${BASE_DIR}/init_sudo.sh

# 2. init HACKER USER bin
mkdir -p ${HACKER_USER_BIN_DIR}
cp ${BASE_DIR}/../conf/env_sets ${HACKER_USER_BIN_DIR}/
cp ${BASE_DIR}/../bin/* ${HACKER_USER_BIN_DIR}/
chown -R ${HACKER_USER} ${HACKER_USER_BIN_DIR}

# 3.init HACKER USER PATH
bashrc_file=${HACKER_USER_HOME_DIR}/.bashrc

if grep -q '^export PATH=' ${bashrc_file};then
    if ! grep -q "${HACKER_USER_BIN_DIR}" ${bashrc_file};then
        sed -i "s/\(^export PATH=\)\(.*\)/\1$(echo ${HACKER_USER_BIN_DIR} | sed 's/\//\\\//g'):\2/" ${bashrc_file}
    fi
else
    echo "export PATH=${HACKER_USER_BIN_DIR}:\$PATH" >> ${bashrc_file}
fi

# 4. init program directory
chown -R ${HACKER_SUPER_USER} ${PROGRAM_DIR}
chmod -R g-x ${PROGRAM_DIR}
chmod -R g-w ${PROGRAM_DIR}
chmod -R g-r ${PROGRAM_DIR}
chmod -R o-x ${PROGRAM_DIR}
chmod -R o-w ${PROGRAM_DIR}
chmod -R o-r ${PROGRAM_DIR}

echo "Install succeed."
echo "su - ${HACKER_USER} && run COMMANDS for checking..."
