import typing
import os

from .models import *
from .steps import android, common, arch


def get_android_scenario(f: typing.TextIO) -> list:
    stps = []
    stps.append(android.pip_termcolor(f))
    stps.append(android.termux_packages(f))
    stps.append(android.npm_packages_pyright(f))
    stps.append(android.configure_shell(f))
    stps.append(android.zsh_autosuggestions_install(f))
    stps.append(android.zsh_highlighting_install(f))
    stps.append(android.zsh_powerlevel10k_install(f))
    stps.append(common.zsh_plugins_dir(f))
    stps.append(common.zsh_fzf(f, "/data/data/com.termux/files/usr/share/fzf"))
    stps.append(common.zsh_bd(f))
    stps.append(common.zsh_external(f))
    stps.append(common.zsh_histfile_dir(f))
    stps.append(android.gopls_install(f))
    stps.append(common.zsh_autosuggestions_link(f, f"{os.getenv('HOME')}/.local/share/zsh-autosuggestions"))
    stps.append(common.zsh_highlighting_link(f, f"{os.getenv('HOME')}/.local/share/zsh-syntax-highlighting"))
    stps.append(common.zsh_powerlevel10k_link(f, f"{os.getenv('HOME')}/.local/share/zsh-powerlevel10k"))
    stps.append(android.termux_config(f))
    return stps


def get_arch_scenario(config: Config, f: typing.TextIO) -> list:
    stps = []
    stps.append(arch.pacman_config(f))
    stps.append(arch.pacman_packages(config.device, f))
    stps.append(arch.yay_install(f))
    stps.append(arch.yay_packages(config.device, f))
    stps.append(arch.configure_shell(f))
    stps.append(common.zsh_plugins_dir(f))
    stps.append(common.zsh_autosuggestions_link(f, "/usr/share/zsh/plugins/zsh-autosuggestions"))
    stps.append(common.zsh_highlighting_link(f, "/usr/share/zsh/plugins/zsh-syntax-highlighting"))
    stps.append(common.zsh_powerlevel10k_link(f, "/usr/share/zsh-theme-powerlevel10k"))
    stps.append(common.zsh_fzf(f, "/usr/share/fzf"))
    stps.append(common.zsh_bd(f))
    stps.append(common.zsh_external(f))
    stps.append(common.zsh_histfile_dir(f))
    stps.append(arch.enable_ntp(f))
    stps.append(arch.wireguard(config.device, f))
    if config.device in [Device.PC, Device.LAPTOP]:
        stps.append(arch.font_jetbrains(f))
        stps.append(arch.font_nerd(f))
        stps.append(arch.bootstrap_pipewire(f))
        stps.append(arch.bootstrap_ly(f))
        stps.append(arch.bootstrap_bluetooth(f))
        stps.append(arch.hypr_paper(f, config))
        stps.append(arch.hypr_external_config(f, config))
        stps.append(arch.rust_set_toolchain(f))
        stps.append(arch.rust_install_analyzer(f))
    return stps


def get_scenario(config: Config, log_fd: typing.TextIO) -> list:
    match config.installation:
        case Installation.ANDROID:
            return get_android_scenario(log_fd)
        case Installation.ARCH:
            return get_arch_scenario(config, log_fd)
    raise RuntimeError()
