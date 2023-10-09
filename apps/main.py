import os
import sys

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..')))
from hacker_commands.apps.hacker_commands import HackerCommands


if __name__ == '__main__':
    # sys.argv[0] is python script file, should be exclude
    args = sys.argv[1:]

    # For transfer SHELL parameters TEXT: options=$(echo "$@")
    if len(args) == 1:
        args = [x for x in args[0].split(' ') if x != '']

    # default conf path
    conf_file = (os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'conf', 'commands.yml')))

    # generate command
    commad_head = "source ~/.bashrc"
    customer_command = HackerCommands(args, conf_file).generate_command()
    command = '{};{}'.format(commad_head, customer_command)

    # run command
    os.system(command)
