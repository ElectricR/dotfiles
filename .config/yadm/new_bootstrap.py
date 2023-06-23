import uuid
from steps.arch import *

with open("/tmp/yadm_bootstrap_{}".format(uuid.uuid4()), 'w') as f:
    print(f.name)
    stps = []
    stps.append(pacman_packages(f))
    stps.append(yay_install(f))
    stps.append(yay_packages(f))
    stps.append(yadm_awesome_init_submodules(f))
    stps.append(font_jetbrains(f))
    stps.append(font_nerd(f))
    stps.append(font_iosevka(f))
    stps.append(configure_shell(f))
    stps.append(bootstrap_pipewire(f))
    stps.append(bootstrap_ly(f))
    stps.append(bootstrap_bluetooth(f))
    stps.append(zsh_autosuggestions_link(f))
    stps.append(zsh_highlighting_link(f))
    stps.append(zsh_host_specific(f, "pc"))
    stps.append(hypr_paper(f, "pc"))
    stps.append(hypr_external_config(f, "pc"))
    stps.append(rust_set_toolchain(f))
    stps.append(rust_install_analyzer(f))

    for s in stps:
        result = s()
        print(result)
