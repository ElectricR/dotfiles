from .utils import default_result
import os
import subprocess
import typing
import shutil

ARCH_PACKAGES = {"openssh", "clang", "gopls", "pyright", "fakeroot", "wget", "make", "fd", "bat", "lua-language-server", "rustup", "fzf", "tmux", "tldr", "task", "zsh-autosuggestions", "zsh-syntax-highlighting", "zathura", "zathura-pdf-mupdf", "npm", "bluez", "bluez-utils", "pipewire", "pipewire-pulse", "firefox", "tree", "htop", "go", "picom", "kitty", "ripgrep", "cmake", "zsh", "unzip", "neovim", "python-pip", "nodejs", "wireplumber", "exa", "duf", "dust"}

# Remove after flameshot fix its stuff
ARCH_PACKAGES.union({"wl-clipboard", "grim", "slurp"})

YAY_PACKAGES = {"hyprland-git", "hyprpaper-git", "hyprpicker-git", "ly"}

def pacman_packages(log_fd: typing.IO) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result['name'] = 'pacman_packages'
        packages_call_result = subprocess.run("pacman -Qqe".split(), stdout=subprocess.PIPE, stderr=log_fd)
        if packages_call_result.returncode != 0:
            return result
        installed_packages = set(packages_call_result.stdout.decode().split())
        if ARCH_PACKAGES - installed_packages:
            if subprocess.run("sudo pacman -Suy --noconfirm {}".format(' '.join(ARCH_PACKAGES - installed_packages)).split(), stdout=log_fd, stderr=log_fd).returncode:
                return result
            result['changes'].append('following pacman packages were installed: {}'.format(' '.join(ARCH_PACKAGES - installed_packages)))
        result['result'] = True
        return result
    return run


def yay_install(log_fd: typing.IO) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result['name'] = 'yay_install'
        if shutil.which("yay") is None:
            if subprocess.run("git clone https://aur.archlinux.org/yay-bin.git".split(), stdout=log_fd, stderr=log_fd).returncode:
                return result
            if subprocess.run("makepkg -si --noconfirm".split(), cwd=os.path.join(os.getcwd(), "yay-bin"), stdout=log_fd, stderr=log_fd).returncode:
                return result
            result['changes'].append('yay binary has been installed')
            shutil.rmtree(os.path.join(os.getcwd(), "yay-bin"))
        result['result'] = True
        return result
    return run

def yay_packages(log_fd: typing.IO) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result['name'] = 'yay_packages'
        packages_call_result = subprocess.run("yay -Qqe".split(), stdout=subprocess.PIPE, stderr=log_fd)
        if packages_call_result.returncode != 0:
            return result
        installed_packages = set(packages_call_result.stdout.decode().split())
        if YAY_PACKAGES - installed_packages:
            if subprocess.run("yay -Suy --noconfirm {}".format(' '.join(YAY_PACKAGES - installed_packages)).split(), stdout=log_fd, stderr=log_fd).returncode:
                return result
            result['changes'].append('following yay packages were installed: {}'.format(' '.join(YAY_PACKAGES - installed_packages)))
        result['result'] = True
        return result
    return run

def font_jetbrains(log_fd: typing.IO) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result['name'] = 'font_jetbrains'
        if not os.path.isdir("/usr/share/fonts/jetbrains"):
            if subprocess.run("wget https://download.jetbrains.com/fonts/JetBrainsMono-2.242.zip".split(), stdout=log_fd, stderr=log_fd).returncode:
                return result
            if subprocess.run("sudo unzip JetBrainsMono-2.242.zip -d /usr/share/fonts/jetbrains".split(), stdout=log_fd, stderr=log_fd).returncode:
                return result
            result['changes'].append('jetbrains font added')
            if subprocess.run("rm JetBrainsMono-2.242.zip".split(), stdout=log_fd, stderr=log_fd).returncode:
                return result
        result['result'] = True
        return result
    return run


def font_nerd(log_fd: typing.IO) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result['name'] = 'font_nerd'
        if not os.path.isdir("/usr/share/fonts/nerd"):
            if subprocess.run("wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Ubuntu.zip".split(), stdout=log_fd, stderr=log_fd).returncode:
                return result
            if subprocess.run("sudo unzip Ubuntu.zip -d /usr/share/fonts/nerd".split(), stdout=log_fd, stderr=log_fd).returncode:
                return result
            result['changes'].append('nerd font added')
            if subprocess.run("rm Ubuntu.zip".split(), stdout=log_fd, stderr=log_fd).returncode:
                return result
        result['result'] = True
        return result
    return run

def font_iosevka(log_fd: typing.IO) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result['name'] = 'font_iosevka'
        if not os.path.isdir("/usr/share/fonts/iosevka"):
            if subprocess.run("wget https://github.com/be5invis/Iosevka/releases/download/v15.0.2/ttf-iosevka-15.0.2.zip".split(), stdout=log_fd, stderr=log_fd).returncode:
                return result
            if subprocess.run("sudo unzip ttf-iosevka-15.0.2.zip -d /usr/share/fonts/iosevka".split(), stdout=log_fd, stderr=log_fd).returncode:
                return result
            result['changes'].append('iosevka font added')
            if subprocess.run("rm ttf-iosevka-15.0.2.zip".split(), stdout=log_fd, stderr=log_fd).returncode:
                return result
        result['result'] = True
        return result
    return run

def configure_shell(log_fd: typing.IO) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result['name'] = 'configure_shell'
        if os.getenv("SHELL") != "/bin/zsh":
            if subprocess.run("sudo chsh -s /bin/zsh er".split(), stdout=log_fd, stderr=log_fd).returncode:
                return result
            result['changes'].append('shell changed to zsh')
        result['result'] = True
        return result
    return run


def bootstrap_pipewire(log_fd: typing.IO) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result['name'] = 'bootstrap_pipewire'
        retcode = subprocess.run("systemctl --user is-enabled pipewire-pulse".split(), stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL).returncode
        if retcode == 1:
            if subprocess.run("systemctl --user enable --now pipewire-pulse".split(), stdout=log_fd, stderr=log_fd).returncode:
                return result
            result['changes'].append('pipewire-pulse has been enabled')
        elif retcode != 0:
            return result
        result['result'] = True
        return result
    return run


def bootstrap_ly(log_fd: typing.IO) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result['name'] = 'bootstrap_ly'
        retcode = subprocess.run("systemctl is-enabled ly".split(), stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL).returncode
        if retcode == 1:
            if subprocess.run("sudo systemctl enable ly".split(), stdout=log_fd, stderr=log_fd).returncode:
                return result
            result['changes'].append('ly service has been enabled')
        elif retcode != 0:
            return result
        result['result'] = True
        return result
    return run

def bootstrap_bluetooth(log_fd: typing.IO) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result['name'] = 'bootstrap_bluetooth'
        retcode = subprocess.run("systemctl is-enabled bluetooth".split(), stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL).returncode
        if retcode == 1:
            if subprocess.run("sudo systemctl enable --now bluetooth".split(), stdout=log_fd, stderr=log_fd).returncode:
                return result
            result['changes'].append('bluetooth service has been enabled')
        elif retcode != 0:
            return result
        result['result'] = True
        return result
    return run

def yadm_awesome_init_submodules(log_fd: typing.IO) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result['name'] = 'yadm_awesome_init_submodules'
        if len(os.listdir("/home/er/.config/awesome/collision")) == 0:
            if subprocess.run("yadm submodule update --init --recursive".split(), stdout=log_fd, stderr=log_fd).returncode:
                return result
            result['changes'].append('yadm awesome modules have been initialized')
        result['result'] = True
        return result
    return run


def zsh_autosuggestions_link(log_fd: typing.IO) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result['name'] = 'zsh_autosuggestions_link'
        linkpath = "/home/er/.config/zsh/plugins/zsh-autosuggestions"
        if not os.path.islink(linkpath):
            if subprocess.run(f"ln -s /usr/share/zsh/plugins/zsh-autosuggestions {linkpath}".split(), stdout=log_fd, stderr=log_fd).returncode:
                return result
            result['changes'].append('zsh autosuggestions has been installed')
        result['result'] = True
        return result
    return run

def zsh_highlighting_link(log_fd: typing.IO) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result['name'] = 'zsh_highlighting_link'
        linkpath = "/home/er/.config/zsh/plugins/zsh-syntax-highlighting"
        if not os.path.islink(linkpath):
            if subprocess.run(f"ln -s /usr/share/zsh/plugins/zsh-syntax-highlighting {linkpath}".split(), stdout=log_fd, stderr=log_fd).returncode:
                return result
            result['changes'].append('zsh syntax highlighting has been installed')
        result['result'] = True
        return result
    return run

def hypr_paper(log_fd: typing.IO, installation: str) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result['name'] = 'hypr_theme'
        linkpath = "/home/er/.config/hypr/black/hyprpaper.conf"
        if not os.path.islink(linkpath):
            if subprocess.run(f"ln -s /home/er/.config/yadm/conf/{installation}/hyprpaper.conf {linkpath}".split(), stdout=log_fd, stderr=log_fd).returncode:
                return result
            result['changes'].append('hyprpaper config has been linked')
        result['result'] = True
        return result
    return run

def zsh_host_specific(log_fd: typing.IO, installation: str) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result['name'] = 'zsh_host_specific'
        linkpath = "/home/er/.config/zsh/host_specific.zsh"
        if not os.path.islink(linkpath):
            if subprocess.run(f"ln -s /home/er/.config/yadm/conf/{installation}/host_specific.zsh {linkpath}".split(), stdout=log_fd, stderr=log_fd).returncode:
                return result
            result['changes'].append('zsh host-specific config has been set up')
        result['result'] = True
        return result
    return run

def hypr_external_config(log_fd: typing.IO, installation: str) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result['name'] = 'hypr_external_config'
        linkpath = "/home/er/.config/hypr/hyprland_external.conf"
        if not os.path.islink(linkpath):
            if subprocess.run(f"ln -s /home/er/.config/yadm/conf/{installation}/hyprland_external.conf {linkpath}".split(), stdout=log_fd, stderr=log_fd).returncode:
                return result
            result['changes'].append('hyprland external config has been linked')
        result['result'] = True
        return result
    return run

def rust_set_toolchain(log_fd: typing.IO) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result['name'] = 'rust_set_toolchain'
        current_toolchain = subprocess.run("rustup default".split(), stdout=subprocess.PIPE, stderr=log_fd)
        if current_toolchain.returncode != 0:
            return result
        if not current_toolchain.stdout.decode().startswith("nightly"):
            if subprocess.run("rustup default nightly".split(), stdout=log_fd, stderr=log_fd).returncode:
                return result
            result['changes'].append('rustup default toolchain was set to nightly')
        result['result'] = True
        return result
    return run

def rust_install_analyzer(log_fd: typing.IO) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result['name'] = 'rust_install_analyzer'
        if shutil.which("rust-analyzer") is None:
            if subprocess.run("rustup component add rust-analyzer".split(), stdout=log_fd, stderr=log_fd).returncode:
                return result
            result['changes'].append('rust analyzer has been installed')
        result['result'] = True
        return result
    return run
