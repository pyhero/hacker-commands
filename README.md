# hacker-commands

Hacker commands for read-only user

## Getting started

### Set HACKER conf
```
vim hacker-commands/conf/env_sets
```
```
# define program father directory
export HACKER_PROGRAM_DIR="/data"

# define read-only username
export HACKER_USER="opadmin"

# define super usnername
export HACKER_SUPER_USER="root"

```

### Config commands
```
vim hacker-commands/conf/commands.yml
```
```
"yarn":
  "app": []
  "application":
    - "-list"
  "logs": []
  "top": []
```

### Install (Need to run on every server)
```
sudo /bin/sh hacker-commands/scripts/install.sh
```

### Add command: kafka-topics
```
vim hacker-commands/conf/commands.yml
```
增加：
```
"kafka-topics":
  "--version": []
  "--describe": []
  "--list": []
  "--topic": []
```
```
cp -a ${HACKER_USER_HOME_DIR}/bin/yarn ${HACKER_USER_HOME_DIR}/bin/kafka-topics
```

### Sync conf
```
sudo /bin/sh hacker-commands/scripts/sync_conf.sh hosts.txt
```

### Uninstall (Need to run on every server)
```
sudo /bin/sh hacker-commands/scripts/uninstall.sh
```
