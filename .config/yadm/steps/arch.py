from .utils import default_result, setup_link
import os
import subprocess
import typing
import shutil

ARCH_PACKAGES_BASE = {
    "tmux",
    "tree",
    "htop",
    "btop",
    "fzf",
    # core
    "ntp",
    # nets
    "openbsd-netcat",
    "openssh",
    "wireguard-tools",
    "ufw",
    # editing
    "neovim",
    "clang",
    # neoutils
    "fd",
    "bat",
    "eza",
    "duf",
    "dust",
    "ripgrep",
    # zsh
    "zsh",
    "zsh-autosuggestions",
    "zsh-syntax-highlighting",
    "zsh-theme-powerlevel10k",
    # bootstrap
    "python-termcolor",
    "fakeroot",  # indirect for yay
}

ARCH_PACKAGES_EXTRA = {
    "wget",
    "make",
    "rustup",
    "tldr",
    "task",
    "npm",
    "firefox",
    "go",
    "kitty",
    "cmake",
    "unzip",
    "nodejs",
    "pass",
    "newsboat",
    "xdg-utils",
    "sshfs",
    "rclone",
    "translate-shell",
    "noto-fonts-emoji",
    # desktop
    "hyprland",
    "xdg-desktop-portal-hyprland", # <-- zoom screensharing in firefox
    # yubikey
    "libfido2",
    "yubikey-manager",
    # osu
    "fuse2",
    # audio
    "pipewire",
    "pipewire-alsa",
    "pipewire-pulse",
    "wireplumber",
    "bluez",
    "bluez-utils",
    "noise-suppression-for-voice",
    # nets
    "openresolv",
    # editing
    "lua-language-server",
    "gopls",
    "pyright",
    # btrfs
    "compsize",
    # image viewing
    "nsxiv",
    "xorg-xrdb",
    # pdf
    "zathura",
    "zathura-pdf-mupdf",
    # bootstrap
    "pkg-config",  # indirect for yay packages
    "python-black",
}

YAY_PACKAGES_BASE = {"shadowsocks-rust"}
YAY_PACKAGES_EXTRA = {"hyprpaper-git", "hyprpicker-git", "ly", "xdg-ninja"}


def pacman_config(log_fd: typing.IO) -> typing.Callable:
    def ensure_pacman_option(check, pattern, option) -> tuple[list, bool]:
        if subprocess.run(
            "grep {} /etc/pacman.conf".format(check).split(),
            stdout=subprocess.DEVNULL,
            stderr=log_fd,
        ).returncode:
            if (
                subprocess.run(
                    [
                        "sudo",
                        "sed",
                        "-i",
                        f"s/{pattern}/{option}/",
                        "/etc/pacman.conf",
                    ],
                    stdout=subprocess.DEVNULL,
                    stderr=log_fd,
                ).returncode
                == 0
            ):
                return ['"{}" option was added to pacman conf'.format(option)], True
            return [], False
        return [], True

    def update_result(changes, option_result, result) -> None:
        result["changes"].extend(changes)
        result["result"] = result["result"] and option_result

    def run() -> dict:
        result = default_result()
        result["name"] = "pacman_config"
        result["result"] = True

        update_result(*ensure_pacman_option("^Color", "#Color.*", "Color"), result)
        update_result(
            *ensure_pacman_option(
                "^VerbosePkgLists", "#VerbosePkgLists.*", "VerbosePkgLists"
            ),
            result,
        )
        update_result(
            *ensure_pacman_option(
                "^ParallelDownloads", "#ParallelDownloads.*", "ParallelDownloads = 10"
            ),
            result,
        )

        return result
    return run


def pacman_packages(device: str, log_fd: typing.IO) -> typing.Callable:
    def update_pkgconf(in_set: typing.Set) -> None:
        if "pkgconf" in in_set:
            in_set.add("pkg-config")
            in_set.remove("pkgconf")

    def run() -> dict:
        result = default_result()
        result["name"] = "pacman_packages"
        packages_call_result = subprocess.run(
            "pacman -Qqe".split(), stdout=subprocess.PIPE, stderr=log_fd
        )
        if packages_call_result.returncode != 0:
            return result
        installed_packages = set(packages_call_result.stdout.decode().split())
        update_pkgconf(installed_packages)
        pkgs = ARCH_PACKAGES_BASE
        if device != "server":
            pkgs.update(ARCH_PACKAGES_EXTRA)
        if pkgs - installed_packages:
            if subprocess.run(
                "sudo pacman -Suy --noconfirm {}".format(
                    " ".join(pkgs - installed_packages)
                ).split(),
                stdout=log_fd,
                stderr=log_fd,
            ).returncode:
                return result
            result["changes"].append(
                "following pacman packages were installed: {}".format(
                    " ".join(pkgs - installed_packages)
                )
            )
        result["result"] = True
        return result

    return run


def yay_install(log_fd: typing.IO) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result["name"] = "yay_install"
        if shutil.which("yay") is None:
            if subprocess.run(
                "git clone https://aur.archlinux.org/yay-bin.git".split(),
                stdout=log_fd,
                stderr=log_fd,
            ).returncode:
                return result
            if subprocess.run(
                "makepkg -si --noconfirm".split(),
                cwd=os.path.join(os.getcwd(), "yay-bin"),
                stdout=log_fd,
                stderr=log_fd,
            ).returncode:
                return result
            result["changes"].append("yay binary has been installed")
            shutil.rmtree(os.path.join(os.getcwd(), "yay-bin"))
        result["result"] = True
        return result

    return run


def yay_packages(device: str,log_fd: typing.IO) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result["name"] = "yay_packages"
        packages_call_result = subprocess.run(
            "yay -Qqe".split(), stdout=subprocess.PIPE, stderr=log_fd
        )
        if packages_call_result.returncode != 0:
            return result
        installed_packages = set(packages_call_result.stdout.decode().split())
        pkgs = YAY_PACKAGES_BASE
        if device != "server":
            pkgs.update(YAY_PACKAGES_EXTRA)
        if pkgs - installed_packages:
            if subprocess.run(
                "yay -Suy --noconfirm {}".format(
                    " ".join(pkgs - installed_packages)
                ).split(),
                stdout=log_fd,
                stderr=log_fd,
            ).returncode:
                return result
            result["changes"].append(
                "following yay packages were installed: {}".format(
                    " ".join(pkgs - installed_packages)
                )
            )
        result["result"] = True
        return result

    return run


def font_jetbrains(log_fd: typing.IO) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result["name"] = "font_jetbrains"
        if not os.path.isdir("/usr/share/fonts/jetbrains"):
            if subprocess.run(
                "wget https://download.jetbrains.com/fonts/JetBrainsMono-2.242.zip".split(),
                stdout=log_fd,
                stderr=log_fd,
            ).returncode:
                return result
            if subprocess.run(
                "sudo unzip JetBrainsMono-2.242.zip -d /usr/share/fonts/jetbrains".split(),
                stdout=log_fd,
                stderr=log_fd,
            ).returncode:
                return result
            result["changes"].append("jetbrains font added")
            if subprocess.run(
                "rm JetBrainsMono-2.242.zip".split(), stdout=log_fd, stderr=log_fd
            ).returncode:
                return result
        result["result"] = True
        return result

    return run


def font_nerd(log_fd: typing.IO) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result["name"] = "font_nerd"
        if not os.path.isdir("/usr/share/fonts/nerd"):
            if subprocess.run(
                "wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Ubuntu.zip".split(),
                stdout=log_fd,
                stderr=log_fd,
            ).returncode:
                return result
            if subprocess.run(
                "sudo unzip Ubuntu.zip -d /usr/share/fonts/nerd".split(),
                stdout=log_fd,
                stderr=log_fd,
            ).returncode:
                return result
            result["changes"].append("nerd font added")
            if subprocess.run(
                "rm Ubuntu.zip".split(), stdout=log_fd, stderr=log_fd
            ).returncode:
                return result
        result["result"] = True
        return result

    return run


def configure_shell(log_fd: typing.IO) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result["name"] = "configure_shell"
        if os.getenv("SHELL") != "/bin/zsh":
            if subprocess.run(
                "sudo chsh -s /bin/zsh er".split(), stdout=log_fd, stderr=log_fd
            ).returncode:
                return result
            result["changes"].append("shell changed to zsh")
        result["result"] = True
        return result

    return run


def bootstrap_pipewire(log_fd: typing.IO) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result["name"] = "bootstrap_pipewire"
        retcode = subprocess.run(
            "systemctl --user is-enabled pipewire-pulse".split(),
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        ).returncode
        if retcode == 1:
            # Do not remove --now until dbus is able to run without restart
            if subprocess.run(
                "systemctl --user enable --now pipewire-pulse".split(),
                stdout=log_fd,
                stderr=log_fd,
            ).returncode:
                return result
            result["changes"].append("pipewire-pulse has been enabled")
        elif retcode != 0:
            return result
        result["result"] = True
        return result

    return run


def bootstrap_ly(log_fd: typing.IO) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result["name"] = "bootstrap_ly"
        retcode = subprocess.run(
            "systemctl is-enabled ly".split(),
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        ).returncode
        if retcode == 1:
            if subprocess.run(
                "sudo systemctl enable ly".split(), stdout=log_fd, stderr=log_fd
            ).returncode:
                return result
            result["changes"].append("ly service has been enabled")
        elif retcode != 0:
            return result
        result["result"] = True
        return result

    return run


def bootstrap_bluetooth(log_fd: typing.IO) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result["name"] = "bootstrap_bluetooth"
        retcode = subprocess.run(
            "systemctl is-enabled bluetooth".split(),
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        ).returncode
        if retcode == 1:
            if subprocess.run(
                "sudo systemctl enable --now bluetooth".split(),
                stdout=log_fd,
                stderr=log_fd,
            ).returncode:
                return result
            result["changes"].append("bluetooth service has been enabled")
        elif retcode != 0:
            return result
        result["result"] = True
        return result

    return run


def hypr_paper(log_fd: typing.IO, installation: str, device: str) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result["name"] = "hypr_theme"
        linkpath = f"{os.getenv('HOME')}/.config/hypr/black/hyprpaper.conf"
        targetpath = f"{os.getenv('HOME')}/.config/yadm/conf/{installation}/{device}/hyprpaper.conf"
        link_res, link_changes = setup_link(log_fd, targetpath, linkpath)
        if link_res:
            result["changes"].extend(link_changes)
        result["result"] = True
        return result

    return run


def hypr_external_config(
    log_fd: typing.IO, installation: str, device: str
) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result["name"] = "hypr_external_config"
        linkpath = f"{os.getenv('HOME')}/.config/hypr/hyprland_external.conf"
        targetpath = f"{os.getenv('HOME')}/.config/yadm/conf/{installation}/{device}/hyprland_external.conf"
        link_res, link_changes = setup_link(log_fd, targetpath, linkpath)
        if link_res:
            result["changes"].extend(link_changes)
        result["result"] = True
        return result

    return run


def rust_set_toolchain(log_fd: typing.IO) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result["name"] = "rust_set_toolchain"
        current_toolchain = subprocess.run(
            "rustup default".split(), stdout=subprocess.PIPE, stderr=log_fd
        )
        if (
            current_toolchain.returncode != 0
            or not current_toolchain.stdout.decode().startswith("nightly")
        ):
            if subprocess.run(
                "rustup default nightly".split(), stdout=log_fd, stderr=log_fd
            ).returncode:
                return result
            result["changes"].append("rustup default toolchain was set to nightly")
        result["result"] = True
        return result

    return run


def rust_install_analyzer(log_fd: typing.IO) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result["name"] = "rust_install_analyzer"
        if shutil.which("rust-analyzer") is None:
            if subprocess.run(
                "rustup component add rust-analyzer".split(),
                stdout=log_fd,
                stderr=log_fd,
            ).returncode:
                return result
            result["changes"].append("rust analyzer has been installed")
        result["result"] = True
        return result

    return run


WIREGUARD_SERVER_TEMPLATE = '''[Interface]
PrivateKey = 
Address = 10.0.0.1
ListenPort = 
PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o !!TODO!! -j MASQUERADE
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o !!TODO!! -j MASQUERADE

# Someone
[Peer]
PublicKey = 
AllowedIPs = 10.0.0.2/32
'''

def wireguard(device: str, log_fd: typing.IO) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result["name"] = "wireguard"
        if subprocess.run(['bash', '-c', 'test "$(stat -c %a /etc/wireguard)" = 711'], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL).returncode != 0:
            if subprocess.run(
                "sudo chmod 711 /etc/wireguard/".split(),
                stdout=log_fd,
                stderr=log_fd,
            ).returncode:
                return result
            result["changes"].append("added x bit to /etc/wireguard")

        if subprocess.run("stat /etc/wireguard/privatekey".split(), stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL).returncode != 0:
            if subprocess.run(
                ["sudo", "bash", "-c", "wg genkey | tee /etc/wireguard/privatekey | wg pubkey > /etc/wireguard/publickey"],
                stdout=log_fd,
                stderr=log_fd,
            ).returncode:
                return result
            result["changes"].append("generated wireguard keys")
            if subprocess.run(
                "sudo chmod 400 /etc/wireguard/publickey /etc/wireguard/privatekey".split(),
                stdout=log_fd,
                stderr=log_fd,
            ).returncode:
                return result
            result["changes"].append("changed mode of wireguard keys")

        if subprocess.run("stat /etc/wireguard/wg0.conf".split(), stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL).returncode != 0:
            if device == "server":
                p = subprocess.Popen(
                    ["sudo", "bash", "-c", "cat > /etc/wireguard/wg0.conf"],
                    stdin=subprocess.PIPE,
                    stdout=log_fd,
                    stderr=log_fd,
                )
                p.communicate(bytes(WIREGUARD_SERVER_TEMPLATE, 'utf-8'))
                if p.returncode != 0:
                    return result
                result["changes"].append("created wireguard config template")
            else:
                if subprocess.run(
                    "sudo touch /etc/wireguard/wg0.conf".split(),
                    stdout=log_fd,
                    stderr=log_fd,
                ).returncode:
                    return result
                result["changes"].append("created wireguard config stub")

            if subprocess.run(
                "sudo chmod 600 /etc/wireguard/wg0.conf".split(),
                stdout=log_fd,
                stderr=log_fd,
            ).returncode:
                return result
            result["changes"].append("changed mode of wireguard config")

            if device == "server":
                if subprocess.run(
                    ["sudo", "bash", "-c", "echo net.ipv4.ip_forward=1 >> /etc/sysctl.d/99-sysctl.conf; sysctl --system"],
                    stdout=log_fd,
                    stderr=log_fd,
                ).returncode:
                    return result
                result["changes"].append("enabled ipv4 forwarding")

        result["result"] = True
        return result

    return run


def enable_ntp(log_fd: typing.IO) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result["name"] = "enable_ntp"
        retcode = subprocess.run(
            "systemctl is-enabled ntpd".split(),
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        ).returncode
        if retcode == 1:
            if subprocess.run(
                "sudo systemctl enable --now ntpd".split(), stdout=log_fd, stderr=log_fd
            ).returncode:
                return result
            result["changes"].append("ntpd service has been enabled")
        elif retcode != 0:
            return result

        retcode = subprocess.run(
            "systemctl is-enabled ntpdate".split(),
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        ).returncode
        if retcode == 1:
            if subprocess.run(
                "sudo systemctl enable --now ntpdate".split(), stdout=log_fd, stderr=log_fd
            ).returncode:
                return result
            result["changes"].append("ntpdate service has been enabled")
        elif retcode != 0:
            return result
        result["result"] = True
        return result

    return run
