import os
import yaml
from collections import OrderedDict


def ordered_yaml_load(yaml_path, Loader=yaml.Loader, object_pairs_hook=OrderedDict):
    """
    Desc: ordered yaml loader
    Args:
        yaml_path: the path of yaml file to load

    Returns: ordered dict

    """
    class OrderedLoader(Loader):
        pass

    def construct_mapping(loader, node):
        loader.flatten_mapping(node)
        return object_pairs_hook(loader.construct_pairs(node))

    OrderedLoader.add_constructor(
        yaml.resolver.BaseResolver.DEFAULT_MAPPING_TAG, construct_mapping)

    with open(yaml_path, encoding='utf-8') as stream:
        return yaml.load(stream, OrderedLoader)


def ordered_yaml_dump(data, stream=None, Dumper=yaml.SafeDumper, **kwds):
    """
    Desc: ordered yaml dumper
    Args:
        data: dict data

    Returns: ordered yaml data

    """
    class OrderedDumper(Dumper):
        pass

    def _dict_representer(dumper, data):
        return dumper.represent_mapping(
            yaml.resolver.BaseResolver.DEFAULT_MAPPING_TAG, data.items())

    OrderedDumper.add_representer(OrderedDict, _dict_representer)
    OrderedDumper.ignore_aliases = lambda self, data: True

    return yaml.dump(data, stream, OrderedDumper, width=2048, **kwds)


def yaml_reader(yaml_file):
    """
    Desc: ordered yaml reader
    Args:
        yaml_file: the path of yaml file to read

    Returns: ordered dict

    """
    if not os.path.exists(yaml_file):
        raise Exception('{}: not exist.'.format(yaml_file))

    contents = ordered_yaml_load(yaml_file)

    return contents


def yaml_writer(contents, yaml_file):
    """
    Desc: ordered yaml writer
    Args:
        contents: ordered dict
        yaml_file: the path of yaml file to write

    Returns: the path of yaml file

    """
    contents = ordered_yaml_dump(contents, default_flow_style=False)
    with open(yaml_file, 'w', encoding='utf-8') as f:
        f.write(contents)

    return yaml_file
