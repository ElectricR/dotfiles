import common
import os
import os.path

ANDROID_PACKAGES = ["wget", "tmux", "taskwarrior", "tree", "zsh", "golang"]

#####################
# Steps
#####################

def configure_shell():
    retcode = os.system("chsh -s zsh")
    return 1 if retcode else 0


def install_packages() -> int:
    package_manager = "pkg install"
    retcode = os.system(f"{package_manager} " + ' '.join(ANDROID_PACKAGES))
    return 2 if retcode else 0


def nvim_packer_install():
    retcode = os.system("git clone --depth 1 https://github.com/wbthomason/packer.nvim $HOME/.local/share/nvim/site/pack/packer/start/packer.nvim")
    return 2 if retcode else 0


def gopls_install():
    retcode = os.system("go install golang.org/x/tools/gopls@latest")
    return 2 if retcode else 0

#####################
# Main
#####################
def bootstrap():
    def zsh_prompt_icon():
        return common.zsh_prompt_icon('PROMPT_HOST_SPECIFIC_ICON="A "')
    steps = [install_packages, configure_shell, common.zsh_bd, zsh_prompt_icon, nvim_packer_install, common.bootstrap_nvim, gopls_install]
    common.bootstrap(steps)
