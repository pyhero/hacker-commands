import os
import sys

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..')))
from hacker_commands.apps.hacker_yaml import yaml_reader


class HackerCommands(object):
    def __init__(self, args: list, conf_file: str) -> None:
        self.args = args
        self.conf_file = conf_file

        # balabla
        self.command = 'echo "Hello Panda"'
        self.conf = self.load_conf()

    def load_conf(self) -> dict:
        if not os.path.exists(self.conf_file):
            raise Exception('conf file [{}] not exist'.format(self.conf_file))

        conf = dict(yaml_reader(self.conf_file))

        return conf

    def check_head_args(self) -> bool:
        if len(self.args) < 1:
            return False

        if self.args[0] not in self.conf:
            self.command = 'echo "[L0] only have permission to run:\n\n\t{}\n"'.format([key for key in self.conf.keys()])

            return False

        if len(self.args) == 1:
            self.command = '{} --help'.format(self.args[0])

            return False

        return True

    def check_tail_args(self) -> bool:
        sub_commands = self.conf[self.args[0]]

        if self.args[1] not in sub_commands:
            self.command = 'echo "[L1] only have permission to run:\n\n\t{} {}\n"'.format(self.args[0], [key for key in sub_commands.keys()])

            return False
        
        if len(self.args) == 2:
            self.command = ' '.join(self.args)

            return True

        support_options_list = sub_commands[self.args[1]]

        # TODO mothership config get

        if self.args[2] not in support_options_list and len(support_options_list) >= 1:
            self.command = 'echo "[L2] only have permission to run:\n\n\t{} {} {}\n"'.format(self.args[0], self.args[1], support_options_list)

            return False
        
        self.command = ' '.join(self.args)

        return True

    def generate_command(self) -> str:
        if self.check_head_args():
            self.check_tail_args()
        
        return self.command
