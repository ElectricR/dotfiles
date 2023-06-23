import common
import subprocess
import os
import os.path



def tmux_plugin():
    if not os.path.exists("/home/er/.tmux/plugins/tpm"):
        retcode = os.system("git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm")
        return 1 if retcode else 0
    return 0

#####################
# Main
#####################

def bootstrap(pc_name_in):
    def zsh_fzf_wrapper():
        return common.zsh_fzf("/usr/share/fzf/key-bindings.zsh")

    if subprocess.run(["whoami"], stdout=subprocess.PIPE).stdout.decode().strip() != "er":
        print("User is not ER")
        exit(42)
    step = input("Step? (default=all):\n\t")
    if step.strip() == '':
        steps = [pc_specific_configs_wrapper, install_packages, init_submodules, yay_install, install_yay_packages, bootstrap_pipewire, configure_shell, common.zsh_bd, common.zsh_external_placeholder, zsh_prompt_icon, zsh_highlighting_link, zsh_autosuggestions_link, zsh_fzf_wrapper, rust_install, fonts_install, tmux_plugin, enable_ly, enable_bluetooth]
        common.bootstrap(steps)
    else:
        exec(f"{step.strip()}()")
