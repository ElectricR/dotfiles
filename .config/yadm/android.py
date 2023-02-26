import common
import os
import os.path

ANDROID_PACKAGES = ["wget", "tmux", "taskwarrior", "tree", "zsh", "golang", "exa", "bat", "fzf", "ripgrep"]

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
    retcode = os.system("test -d $HOME/.local/share/nvim/site/pack/packer/start || git clone --depth 1 https://github.com/wbthomason/packer.nvim $HOME/.local/share/nvim/site/pack/packer/start/packer.nvim")
    return 2 if retcode else 0


def gopls_install():
    retcode = os.system("go install golang.org/x/tools/gopls@latest")
    return 1 if retcode else 0


def zsh_autosuggestions():
    dir_path = "$HOME/.config/zsh/plugins"
    retcode = os.system(f"test -d {dir_path}/zsh-autosuggestions || (cd {dir_path} && git clone https://github.com/zsh-users/zsh-autosuggestions)")
    return 1 if retcode else 0


def zsh_highlighting():
    dir_path = "$HOME/.config/zsh/plugins"
    retcode = os.system(f"test -d {dir_path}/zsh-syntax-highlighting || (cd {dir_path} && git clone https://github.com/zsh-users/zsh-syntax-highlighting)")
    return 1 if retcode else 0


#####################
# Main
#####################
def bootstrap():
    def zsh_prompt_icon():
        return common.zsh_prompt_icon('PROMPT_HOST_SPECIFIC_ICON="A "')
    def zsh_fzf_wrapper():
        return common.zsh_fzf("/data/data/com.termux/files/usr/share/fzf/key-bindings.zsh")

    steps = [install_packages, configure_shell, common.zsh_external_placeholder, common.zsh_bd, zsh_prompt_icon, zsh_fzf_wrapper, zsh_highlighting, zsh_autosuggestions, nvim_packer_install, gopls_install]
    common.bootstrap(steps)
