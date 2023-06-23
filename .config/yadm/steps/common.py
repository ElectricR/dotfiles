from .utils import default_result
import typing
import os
import subprocess

def yadm_awesome_init_submodules(log_fd: typing.IO) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result['name'] = 'yadm_awesome_init_submodules'
        if len(os.listdir(f"{os.getenv('HOME')}/.config/awesome/collision")) == 0:
            if subprocess.run("yadm submodule update --init --recursive".split(), stdout=log_fd, stderr=log_fd).returncode:
                return result
            result['changes'].append('yadm awesome modules have been initialized')
        result['result'] = True
        return result
    return run

def zsh_host_specific(log_fd: typing.IO, installation: str) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result['name'] = 'zsh_host_specific'
        linkpath = f"{os.getenv('HOME')}/.config/zsh/host_specific.zsh"
        if not os.path.islink(linkpath):
            if subprocess.run(f"ln -s {os.getenv('HOME')}/.config/yadm/conf/{installation}/host_specific.zsh {linkpath}".split(), stdout=log_fd, stderr=log_fd).returncode:
                return result
            result['changes'].append('zsh host-specific config has been set up')
        result['result'] = True
        return result
    return run

