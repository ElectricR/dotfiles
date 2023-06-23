import steps.android as android
import steps.common as common
import typing
import os


def get_scenario(f: typing.TextIO) -> list:
    stps = []
    stps.append(android.termux_packages(f))
    stps.append(android.configure_shell(f))
    stps.append(android.zsh_autosuggestions_install(f))
    stps.append(android.zsh_highlighting_install(f))
    stps.append(common.zsh_host_specific(f, "android"))
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
