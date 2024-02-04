from types import SimpleNamespace
from enum import Enum

class Installation(Enum):
    ARCH = "archlinux"
    ANDROID = "android"


class Device(Enum):
    ANDROID = "android"
    RASPBERRY = "raspberry"
    SERVER = "server"
    PC = "pc"
    LAPTOP = "laptop"


class Secrets(SimpleNamespace):
    serverAddress: str = "<NONE>"
    wgPort: str = "<NONE>"
    wgNode: str = "<NONE>"
    serverXrayPubkey: str = "<NONE>"
    serverXrayId: str = "<NONE>"
    serverSSPort: str = "<NONE>"
    serverWgPubkey: str = "<NONE>"


class Config(SimpleNamespace):
    installation: Installation
    device: Device
    secrets: Secrets
