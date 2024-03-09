import os
import typing
import uuid
import json
from pathlib import Path

from .models import *
from . import scenario

def get_installation(config: Config) -> None:
    if os.getenv("ANDROID_DATA") is not None:
        config.installation = Installation.ANDROID
    else:
        config.installation = Installation.ARCH


def get_device(config: Config) -> None:
    match config.installation:
        case Installation.ANDROID:
            config.device = Device.ANDROID
        case Installation.ARCH:
            # Hacks
            if not os.system("lscpu | grep -q ARM"):
                config.device = Device.RASPBERRY
            elif not os.path.isdir("/sys/firmware/efi"):
                config.device = Device.SERVER
            elif len(os.listdir("/sys/class/backlight")):
                config.device = Device.LAPTOP
            else:
                config.device = Device.PC
        case default:
            raise RuntimeError("Unrecognized device")


def load_secrets(config: Config) -> None:
    path = Path(__file__).parent.parent.joinpath("secrets.json")
    if not path.exists():
        print(f"WARN: {path} does not exist")
        return
    with open(path) as f:
        data = json.load(f)
        config.secrets.wgPort = data.get("wgPort", None)
        config.secrets.wgNode = data.get("wgNode", None)
        config.secrets.serverAddress = data.get("serverAddress", None)
        config.secrets.serverXrayId = data.get("serverXrayId", None)
        config.secrets.serverXrayPubkey = data.get("serverXrayPubkey", None)
        config.secrets.serverWgPubkey = data.get("serverWgPubkey", None)


def validate_user(config: Config) -> None:
    match config.installation:
        case Installation.ANDROID:
            return
        case Installation.ARCH:
            if os.getenv("USER") != "er":
                raise RuntimeError("User is not er")
            return
    raise RuntimeError("Unknown installation")


def get_log_file(config: Config) -> typing.TextIO:
    match config.installation:
        case Installation.ANDROID:
            return open(f"{os.environ['TMPDIR']}/yadm_bootstrap_{uuid.uuid4()}", "w")
        case Installation.ARCH:
            return open("/tmp/yadm_bootstrap_{}".format(uuid.uuid4()), "w")
    raise RuntimeError("Unknown installation")


def colorize_result(result: dict) -> str:
    try:
        import termcolor

        if not result["result"]:
            if result["skipped"]:
                return termcolor.colored(str(result), "yellow")
            return termcolor.colored(str(result), "red")
        elif result["changes"]:
            return termcolor.colored(str(result), "green")
    except:
        pass
    return str(result)


def create_config() -> Config:
    config = Config()
    get_installation(config)
    get_device(config)
    load_secrets(config)
    return config


def main():
    config = create_config()
    validate_user(config)
    with get_log_file(config) as log_fd:
        print(log_fd.name)
        for s in scenario.get_scenario(config, log_fd):
            result = s()
            print(colorize_result(result))
