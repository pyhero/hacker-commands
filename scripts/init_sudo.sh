#!/usr/bin/env bash

# check runner
[ $(whoami) != 'root' ] && echo "run as root" && exit 2

BASE_DIR="$(cd "`dirname $0`" && echo $PWD || exit 2)"

# import HACKER conf
source ${BASE_DIR}/../conf/env_sets

PROGRAM_DIR="${HACKER_PROGRAM_DIR}/hacker-commands"

cat > ${BASE_DIR}/../conf/sudo.hacker_user << EOF
Defaults:${HACKER_USER} !requiretty
Defaults env_keep += "TZ"
${HACKER_USER} ALL=(${HACKER_SUPER_USER}) NOPASSWD: /bin/bash -c ${PROGRAM_DIR}/run_command *
EOF

sudo_file="/etc/sudoers.d/${HACKER_USER}"

if [ -f ${sudo_file} ];then
    cp $sudo_file ${BASE_DIR}/../conf/sudo.${HACKER_USER}.$(date "+%Y-%m-%d")
fi

cp ${BASE_DIR}/../conf/sudo.hacker_user ${sudo_file}
