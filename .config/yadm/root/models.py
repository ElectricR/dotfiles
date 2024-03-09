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
    serverAddress: str|None = None
    wgPort: str|None = None
    wgNode: str|None = None
    serverXrayPubkey: str|None = None
    serverXrayId: str|None = None
    serverSSPort: str|None = None
    serverWgPubkey: str|None = None


class Config(SimpleNamespace):
    installation: Installation
    device: Device
    secrets: Secrets = Secrets()
