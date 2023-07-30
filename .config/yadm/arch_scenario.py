import steps.arch as arch
import steps.common as common
import typing


def get_scenario(installation: str, f: typing.TextIO) -> list:
    stps = []
    stps.append(arch.pacman_config(f))
    stps.append(arch.pacman_packages(f))
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
    stps.append(common.zsh_host_specific(f, installation))
    stps.append(arch.hypr_paper(f, installation))
    stps.append(arch.hypr_external_config(f, installation))
    stps.append(arch.rust_set_toolchain(f))
    stps.append(arch.rust_install_analyzer(f))
    stps.append(common.zsh_fzf(f, "/usr/share/fzf"))
    stps.append(common.zsh_bd(f))
    stps.append(common.zsh_external(f))

    return stps
