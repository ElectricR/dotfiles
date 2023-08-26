from .utils import default_result
import os
import subprocess
import typing
import shutil


ANDROID_PACKAGES = {
    "wget",
    "tmux",
    "taskwarrior",
    "tree",
    "zsh",
    "golang",
    "fzf",
    "pass",
    "jq",
    # neoutils
    "fd",
    "bat",
    "exa",
    "duf",
    "dust",
    "ripgrep",
    # editing
    "lua-language-server",
}


def termux_packages(log_fd: typing.IO) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result["name"] = "termux_packages"
        packages_call_result = subprocess.run(
            ["dpkg-query", "-W", "--no-pager", "-f=${binary:Package}\n"],
            stdout=subprocess.PIPE,
            stderr=log_fd,
        )
        if packages_call_result.returncode != 0:
            return result
        installed_packages = set(packages_call_result.stdout.decode().split())
        if ANDROID_PACKAGES - installed_packages:
            if subprocess.run(
                "pkg install -y {}".format(
                    " ".join(ANDROID_PACKAGES - installed_packages)
                ).split(),
                stdout=log_fd,
                stderr=log_fd,
            ).returncode:
                return result
            result["changes"].append(
                "following termux packages were installed: {}".format(
                    " ".join(ANDROID_PACKAGES - installed_packages)
                )
            )
        result["result"] = True
        return result

    return run


def configure_shell(log_fd: typing.IO) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result["name"] = "configure_shell"
        if not os.getenv("SHELL", "").endswith("zsh"):
            if subprocess.run(
                "chsh -s zsh".split(), stdout=log_fd, stderr=log_fd
            ).returncode:
                return result
            result["changes"].append("shell changed to zsh")
        result["result"] = True
        return result

    return run


def gopls_install(log_fd: typing.IO) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result["name"] = "gopls_install"
        if shutil.which("gopls") is None:
            if subprocess.run(
                "go install golang.org/x/tools/gopls@latest".split(),
                stdout=log_fd,
                stderr=log_fd,
            ).returncode:
                return result
            result["changes"].append("gopls was installed")
        result["result"] = True
        return result

    return run


def zsh_autosuggestions_install(log_fd: typing.IO) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result["name"] = "zsh_autosuggestions_install"
        dirpath = f"{os.getenv('HOME')}/.local/share"
        if not os.path.isdir(dirpath + "/zsh-autosuggestions"):
            if subprocess.run(
                "git clone https://github.com/zsh-users/zsh-autosuggestions".split(),
                cwd=dirpath,
                stdout=log_fd,
                stderr=log_fd,
            ).returncode:
                return result
            result["changes"].append("zsh autosuggestions were successfully installed")
        result["result"] = True
        return result

    return run


def zsh_highlighting_install(log_fd: typing.IO) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result["name"] = "zsh_highlighting_install"
        dirpath = f"{os.getenv('HOME')}/.local/share"
        if not os.path.isdir(dirpath + "/zsh-syntax-highlighting"):
            if subprocess.run(
                "git clone https://github.com/zsh-users/zsh-syntax-highlighting".split(),
                cwd=dirpath,
                stdout=log_fd,
                stderr=log_fd,
            ).returncode:
                return result
            result["changes"].append(
                "zsh syntax highlighting was successfully installed"
            )
        result["result"] = True
        return result

    return run