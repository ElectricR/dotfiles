import common
import subprocess
import os
import os.path

ARCH_PACKAGES = ["openssh", "clang", "gopls", "pyright", "fakeroot", "wget", "make", "fd", "bat", "lua-language-server", "rustup", "fzf", "tmux", "tldr", "task", "zsh-autosuggestions", "zsh-syntax-highlighting", "zathura", "zathura-pdf-mupdf", "xclip", "npm", "bluez", "bluez-utils", "pipewire", "pipewire-pulse", "firefox", "tree", "htop", "xorg", "go", "picom", "kitty", "ripgrep", "xautolock", "slock", "flameshot", "cmake", "zsh", "unzip", "neovim", "curl", "python-pip", "nodejs", "awesome", "pkgconf", "wireplumber", "exa"]
YAY_PACKAGES = ["nvim-packer-git", "hyprland-git", "hyprpaper-git", "hyprpicker-git", "ly"]

# Remove after flameshot fix his stuff
ARCH_PACKAGES += ["wl-clipboard", "grim", "slurp"]

#####################
# Steps
#####################

def install_packages() -> int:
    package_manager = "pacman -Suy"
    distro_specific_packages = ARCH_PACKAGES
    retcode = os.system(f"sudo {package_manager} " + ' '.join(distro_specific_packages))
    return 2 if retcode else 0


def init_submodules():
    retcode = os.system("yadm submodule update --init --recursive")
    return 2 if retcode else 0


def yay_install():
    os.system("rm -rf ~/projects/aur/yay-bin")
    retcode = os.system("mkdir ~/projects/aur -p && cd ~/projects/aur && git clone https://aur.archlinux.org/yay-bin.git && cd ~/projects/aur/yay-bin && makepkg -si")
    return 1 if retcode else 0


def install_yay_packages():
    retcode = os.system(f"yay -Suy " + ' '.join(YAY_PACKAGES))
    return 1 if retcode else 0


def bootstrap_pipewire():
    retcode = os.system("systemctl --user start pipewire-pulse")
    return 1 if retcode else 0


def configure_shell():
    retcode = os.system("sudo chsh -s /bin/zsh er")
    return 1 if retcode else 0


def zsh_external_placeholder():
    retcode = os.system("touch ~/.config/zsh/external.zsh")
    return 1 if retcode else 0


def rust_install():
    retcode = os.system("rustup +nightly component add rust-analyzer-preview && sudo cp ~/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/bin/rust-analyzer /usr/bin && rustup default nightly" )
    return 1 if retcode else 0


def fonts_install():
    retcode = os.system("wget https://download.jetbrains.com/fonts/JetBrainsMono-2.242.zip && unzip JetBrainsMono-2.242.zip -d tempaoeu && sudo mv tempaoeu/fonts/ttf/*.ttf /usr/share/fonts/ && rm JetBrainsMono-2.242.zip tempaoeu -r")
    if retcode: return 1

    os.system("wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Ubuntu.zip && unzip Ubuntu.zip -d tempaoeu && sudo mkdir -p /usr/share/fonts/nerd && sudo mv tempaoeu/*.ttf /usr/share/fonts/nerd && rm Ubuntu.zip tempaoeu -r")
    if retcode: return 1

    os.system("wget https://github.com/be5invis/Iosevka/releases/download/v15.0.2/ttf-iosevka-15.0.2.zip && unzip ttf-iosevka-15.0.2.zip -d tempaoeu && sudo mkdir -p /usr/share/fonts/iosevka && sudo mv tempaoeu/*.ttf /usr/share/fonts/iosevka && rm ttf-iosevka-15.0.2.zip tempaoeu -r")
    return 1 if retcode else 0


def tmux_plugin():
    if not os.path.exists("/home/er/.tmux/plugins/tpm"):
        retcode = os.system("git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm")
        return 1 if retcode else 0
    return 0


def enable_ly():
    retcode = os.system("sudo systemctl enable --now ly")
    return 1 if retcode else 0


def enable_bluetooth():
    retcode = os.system("sudo systemctl enable --now bluetooth")
    return 1 if retcode else 0


LAPTOP_HYPR_EXTERNAL = """monitor=eDP-1,1920x1080@60,0x0,1

decoration {
    rounding=10
    multisample_edges=true
    blur=1
    blur_size=5 # minimum 1
    blur_passes=2 # minimum 1, more passes = more resource intensive.
    # Your blur "amount" is blur_size * blur_passes, but high blur_size (over around 5-ish) will produce artifacts.
    # if you want heavy blur, you need to up the blur_passes.
    # the more passes, the more you can up the blur_size without noticing artifacts.
    blur_new_optimizations=true
}
"""

HOME_PC_HYPR_EXTERNAL = """
monitor=HDMI-A-1,1920x1080@144,0x0,1
monitor=DB-1,1920x1080@144,1920x0,1
monitor=DB-2,1920x1080@144,3840,1

decoration {
    rounding=10
    multisample_edges=true
    blur=1
    blur_size=2 # minimum 1
    blur_passes=1 # minimum 1, more passes = more resource intensive.
    # Your blur "amount" is blur_size * blur_passes, but high blur_size (over around 5-ish) will produce artifacts.
    # if you want heavy blur, you need to up the blur_passes.
    # the more passes, the more you can up the blur_size without noticing artifacts.
    blur_new_optimizations=true
}
"""

def pc_specific_configs(pc_name):
    def configure_lid_close_behavior():
        return os.system("sudo sed -i 's/#HandleLidSwitch=.*/HandleLidSwitch=suspend/' /etc/systemd/logind.conf")
    match pc_name:
        case 'Home PC':
            hypr_external = HOME_PC_HYPR_EXTERNAL
        case 'Laptop':
            hypr_external = LAPTOP_HYPR_EXTERNAL
        case _:
            print("Unknown PC name")
            exit(42)
    retcode = os.system('mkdir -p ~/.config/hypr')
    if retcode: return 1
    with open('/home/er/.config/hypr/hyprland_external.conf', 'w') as f:
        f.write(hypr_external)
    if pc_name == 'Laptop':
        retcode = configure_lid_close_behavior()
        if retcode: return 1

#####################
# Main
#####################

def bootstrap(pc_name_in):
    def pc_specific_configs_wrapper():
        pc_specific_configs(pc_name_in)
    def zsh_prompt_icon():
        return common.zsh_prompt_icon('PROMPT_HOST_SPECIFIC_ICON=" "')
    if subprocess.run(["whoami"], stdout=subprocess.PIPE).stdout.decode().strip() != "er":
        print("User is not ER")
        exit(42)
    step = input("Step? (default=all):\n\t")
    if step.strip() == '':
        steps = [pc_specific_configs_wrapper, install_packages, init_submodules, yay_install, install_yay_packages, bootstrap_pipewire, configure_shell, common.zsh_bd, zsh_external_placeholder, zsh_prompt_icon, rust_install, fonts_install, tmux_plugin, common.bootstrap_nvim, enable_ly, enable_bluetooth]
        common.bootstrap(steps)
    else:
        exec(f"{step.strip()}()")
