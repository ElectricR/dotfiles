from .utils import default_result
import typing
import os
import subprocess


def yadm_awesome_init_submodules(log_fd: typing.IO) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result["name"] = "yadm_awesome_init_submodules"
        if len(os.listdir(f"{os.getenv('HOME')}/.config/awesome/collision")) == 0:
            if subprocess.run(
                "yadm submodule update --init --recursive".split(),
                stdout=log_fd,
                stderr=log_fd,
            ).returncode:
                return result
            result["changes"].append("yadm awesome modules have been initialized")
        result["result"] = True
        return result

    return run


def zsh_host_specific(log_fd: typing.IO, installation: str) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result["name"] = "zsh_host_specific"
        linkpath = f"{os.getenv('HOME')}/.config/zsh/host_specific.zsh"
        if not os.path.islink(linkpath):
            if subprocess.run(
                f"ln -s {os.getenv('HOME')}/.config/yadm/conf/{installation}/host_specific.zsh {linkpath}".split(),
                stdout=log_fd,
                stderr=log_fd,
            ).returncode:
                return result
            result["changes"].append("zsh host-specific config has been set up")
        result["result"] = True
        return result

    return run


def zsh_fzf(log_fd: typing.IO, path: str) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result["name"] = "zsh_fzf"
        linkpath = f"{os.getenv('HOME')}/.config/zsh/plugins/fzf"
        if not os.path.islink(linkpath):
            if subprocess.run(
                f"ln -s {path} {linkpath}".split(), stdout=log_fd, stderr=log_fd
            ).returncode:
                return result
            result["changes"].append("zsh fzf key-bindings have been set up")
        result["result"] = True
        return result

    return run


def zsh_bd(log_fd: typing.IO) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result["name"] = "zsh_bd"
        filepath = f"{os.getenv('HOME')}/.config/zsh/plugins/bd.zsh"
        if not os.path.isfile(filepath):
            if subprocess.run(
                f"curl https://raw.githubusercontent.com/Tarrasch/zsh-bd/master/bd.zsh -o {filepath}".split(),
                stdout=log_fd,
                stderr=log_fd,
            ).returncode:
                return result
            result["changes"].append("zsh bd plugin has been set up")
        result["result"] = True
        return result

    return run


def zsh_external(_: typing.IO) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result["name"] = "zsh_external"
        filepath = f"{os.getenv('HOME')}/.config/zsh/external.zsh"
        if not os.path.isfile(filepath):
            with open(filepath, "w"):
                pass
            result["changes"].append(
                "zsh placeholder for external config has been set up"
            )
        result["result"] = True
        return result

    return run


def zsh_autosuggestions_link(log_fd: typing.IO, path: str) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result["name"] = "zsh_autosuggestions_link"
        linkpath = f"{os.getenv('HOME')}/.config/zsh/plugins/zsh-autosuggestions"
        if not os.path.islink(linkpath):
            if subprocess.run(
                f"ln -s {path} {linkpath}".split(), stdout=log_fd, stderr=log_fd
            ).returncode:
                return result
            result["changes"].append("zsh autosuggestions has been installed")
        result["result"] = True
        return result

    return run


def zsh_highlighting_link(log_fd: typing.IO, path: str) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result["name"] = "zsh_highlighting_link"
        linkpath = f"{os.getenv('HOME')}/.config/zsh/plugins/zsh-syntax-highlighting"
        if not os.path.islink(linkpath):
            if subprocess.run(
                f"ln -s {path} {linkpath}".split(), stdout=log_fd, stderr=log_fd
            ).returncode:
                return result
            result["changes"].append("zsh syntax highlighting has been installed")
        result["result"] = True
        return result

    return run
