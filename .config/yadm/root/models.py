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

    

class Config(SimpleNamespace):
    installation: Installation
    device: Device
