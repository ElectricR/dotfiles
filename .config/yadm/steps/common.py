from .utils import default_result, setup_link
import typing
import os
import subprocess



def zsh_host_specific(
    log_fd: typing.IO, installation: str, device: str
) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result["name"] = "zsh_host_specific"
        linkpath = f"{os.getenv('HOME')}/.config/zsh/host_specific.zsh"
        targetpath = f"{os.getenv('HOME')}/.config/yadm/conf/{installation}/{device}/host_specific.zsh"
        link_res, link_changes = setup_link(log_fd, targetpath, linkpath)
        if link_res:
            result["changes"].extend(link_changes)
        result["result"] = True
        return result

    return run


def zsh_plugins_dir(log_fd: typing.IO) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result["name"] = "zsh_plugins_dir"
        dirpath = f"{os.getenv('HOME')}/.config/zsh/plugins"
        if not os.path.isdir(dirpath):
            if subprocess.run(
                f"mkdir -p {dirpath}".split(), stdout=log_fd, stderr=log_fd
            ).returncode:
                return result
            result["changes"].append("zsh plugins directory has been created")
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
            result["changes"].append("zsh autosuggestions link has been created")
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
            result["changes"].append("zsh syntax highlighting link has been created")
        result["result"] = True
        return result

    return run


def zsh_powerlevel10k_link(log_fd: typing.IO, path: str) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result["name"] = "zsh_powerlevel10k_link"
        linkpath = f"{os.getenv('HOME')}/.config/zsh/plugins/zsh-powerlevel10k"
        if not os.path.islink(linkpath):
            if subprocess.run(
                f"ln -s {path} {linkpath}".split(), stdout=log_fd, stderr=log_fd
            ).returncode:
                return result
            result["changes"].append("zsh powerlevel10k link has been created")
        result["result"] = True
        return result

    return run


def zsh_histfile_dir(log_fd: typing.IO) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result["name"] = "zsh_histfile_dir"
        dirpath = f"{os.getenv('HOME')}/.local/share/zsh/"
        if not os.path.isdir(dirpath):
            try:
                os.mkdir(dirpath)
            except Exception as e:
                print(e)
                return result
            result["changes"].append("zsh histfile dir has been created")
        result["result"] = True
        return result

    return run
