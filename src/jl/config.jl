#parse config.yaml
using YAML

config = YAML.load_file("config.yaml")

config_name = config["name"]