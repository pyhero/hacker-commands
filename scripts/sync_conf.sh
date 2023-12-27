#!/usr/bin/env bash
# run this on excute server

# check runner
[ $(whoami) != 'root' ] && echo "run as root" && exit 2

BASE_DIR="$(cd "`dirname $0`" && echo $PWD || exit 2)"

# import HACKER conf
source ${BASE_DIR}/../conf/env_sets

HACKER_USER_HOME_DIR=$(sudo -u ${HACKER_USER} -i echo \$HOME)
[ -z ${HACKER_USER_HOME_DIR} ] && echo "get ${HACKER_USER}'s home directory failed" && exit 2
HACKER_USER_BIN_DIR="${HACKER_USER_HOME_DIR}/bin"

PROGRAM_DIR="${HACKER_PROGRAM_DIR}/hacker-commands"
CONF_FILE="${PROGRAM_DIR}/conf/commands.yml"
[ ! -f $CONF_FILE ] && echo "conf file [${CONF_FILE}] not exist" && exit 2

if [ $# -lt 1 ];then
    echo "hosts_file is required, run as:"
    echo "  sh $0 {hosts_file}"
    echo "  - hosts_file: one [hostname or ip] one line"
    exit 2
fi

HOSTS_FILE="$1"
[ ! -f $HOSTS_FILE ] && echo "hosts file [${HOSTS_FILE}] not exist" && exit 2

hosts_number=$(grep -v "^$" ${HOSTS_FILE} | grep -v "^#" | wc -l | awk '{print $1}')
echo "There are ${hosts_number} hosts will be sync."

for h in $(cat ${HOSTS_FILE});do
    echo "Syncing to $h:"

    echo -n "sync conf [${CONF_FILE}]:"
    rsync -az ${CONF_FILE} $h:${CONF_FILE}
    echo " done"

    echo -n "sync bin [${HACKER_USER_BIN_DIR}]:"
    rsync -az ${HACKER_USER_BIN_DIR}/* $h:${HACKER_USER_BIN_DIR}/
    echo " done"
done
