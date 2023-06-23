import uuid
import os
import steps.arch as arch
import steps.common as common
import termcolor


def validate_user():
    if os.getenv('USER') != 'er':
        raise RuntimeError("User is not er")

def colorize_result(result: dict) -> str:
    if not result['result']:
        return termcolor.colored(str(result), 'red')
    elif result['changes']:
        return termcolor.colored(str(result), 'green')
    return str(result)


if __name__ == "__main__":
    validate_user()
    with open("/tmp/yadm_bootstrap_{}".format(uuid.uuid4()), 'w') as f:
        print(f.name)
        stps = []
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
        stps.append(arch.zsh_autosuggestions_link(f))
        stps.append(arch.zsh_highlighting_link(f))
        stps.append(common.zsh_host_specific(f, "laptop"))
        stps.append(arch.hypr_paper(f, "laptop"))
        stps.append(arch.hypr_external_config(f, "laptop"))
        stps.append(arch.rust_set_toolchain(f))
        stps.append(arch.rust_install_analyzer(f))

        for s in stps:
            result = s()
            print(colorize_result(result))
