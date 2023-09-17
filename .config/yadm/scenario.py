import typing
import os

import steps.android as android
import steps.arch as arch
import steps.common as common


def get_android_scenario(installation: str, device: str, f: typing.TextIO) -> list:
    stps = []
    stps.append(android.pip_termcolor(f))
    stps.append(android.termux_packages(f))
    stps.append(android.npm_packages_pyright(f))
    stps.append(android.configure_shell(f))
    stps.append(android.zsh_autosuggestions_install(f))
    stps.append(android.zsh_highlighting_install(f))
    stps.append(common.zsh_host_specific(f, installation, device))
    stps.append(common.zsh_plugins_dir(f))
    stps.append(common.zsh_fzf(f, "/data/data/com.termux/files/usr/share/fzf"))
    stps.append(common.zsh_bd(f))
    stps.append(common.zsh_external(f))
    stps.append(android.gopls_install(f))
    stps.append(
        common.zsh_autosuggestions_link(
            f, f"{os.getenv('HOME')}/.local/share/zsh-autosuggestions"
        )
    )
    stps.append(
        common.zsh_highlighting_link(
            f, f"{os.getenv('HOME')}/.local/share/zsh-syntax-highlighting"
        )
    )
    return stps


def get_arch_server_scenario(installation: str, device: str, f: typing.TextIO) -> list:
    stps = []
    stps.append(arch.pacman_config(f))
    stps.append(arch.pacman_packages(device, f))
    stps.append(arch.configure_shell(f))
    stps.append(common.zsh_plugins_dir(f))
    stps.append(
        common.zsh_autosuggestions_link(f, "/usr/share/zsh/plugins/zsh-autosuggestions")
    )
    stps.append(
        common.zsh_highlighting_link(
            f, "/usr/share/zsh/plugins/zsh-syntax-highlighting"
        )
    )
    stps.append(common.zsh_host_specific(f, installation, device))
    stps.append(common.zsh_fzf(f, "/usr/share/fzf"))
    stps.append(common.zsh_bd(f))
    stps.append(common.zsh_external(f))
    return stps


def get_arch_scenario(installation: str, device: str, f: typing.TextIO) -> list:
    if device == "server":
        return get_arch_server_scenario(installation, device, f)
    stps = []
    stps.append(arch.pacman_config(f))
    stps.append(arch.pacman_packages(device, f))
    stps.append(arch.yay_install(f))
    stps.append(arch.yay_packages(f))
    stps.append(common.yadm_awesome_init_submodules(f))
    stps.append(arch.font_jetbrains(f))
    stps.append(arch.font_nerd(f))
    stps.append(arch.font_iosevka(f))
    stps.append(arch.configure_shell(f))
    stps.append(arch.bootstrap_pipewire(f))
    stps.append(arch.bootstrap_ly(f))
    stps.append(arch.bootstrap_bluetooth(f))
    stps.append(common.zsh_plugins_dir(f))
    stps.append(
        common.zsh_autosuggestions_link(f, "/usr/share/zsh/plugins/zsh-autosuggestions")
    )
    stps.append(
        common.zsh_highlighting_link(
            f, "/usr/share/zsh/plugins/zsh-syntax-highlighting"
        )
    )
    stps.append(common.zsh_host_specific(f, installation, device))
    stps.append(arch.hypr_paper(f, installation, device))
    stps.append(arch.hypr_external_config(f, installation, device))
    stps.append(arch.rust_set_toolchain(f))
    stps.append(arch.rust_install_analyzer(f))
    stps.append(common.zsh_fzf(f, "/usr/share/fzf"))
    stps.append(common.zsh_bd(f))
    stps.append(common.zsh_external(f))
    return stps


def get_scenario(installation: str, device: str, log_fd: typing.TextIO) -> list:
    match installation:
        case "android":
            return get_android_scenario(installation, device, log_fd)
        case "archlinux":
            return get_arch_scenario(installation, device, log_fd)
    raise RuntimeError()
