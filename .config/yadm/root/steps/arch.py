from .utils import default_result, setup_link
from . import utils
import sys
import os
import subprocess
import typing
import shutil
import uuid

sys.path.append("..")
from ..models import *

ARCH_PACKAGES_HEADLESS = {
    "tmux",
    "tree",
    "fzf",
    "rsync",
    "man-pages",
    # system tools
    "bind", # <- dig tool
    "nload",
    "mtr",
    "lsof",
    "htop",
    "btop",
    "strace",
    "openbsd-netcat",
    "tcpdump",
    # core
    "ntp",
    "make",
    "cmake",
    # nets
    "openssh",
    "wireguard-tools",
    "ufw",
    # editing
    "neovim",
    "helix",
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

ARCH_PACKAGES_HEADLESS_EXTRA = {
    # services
    "task",
    "timew",
    "newsboat",
    "neomutt",
    # utils
    "tldr",
    "wget",
    "unzip",
    "translate-shell",
    "sshfs",
}

ARCH_PACKAGES_DESKTOP = {
    # desktop
    "hyprland",
    "hyprpaper",
    "xdg-desktop-portal-hyprland", # <-- zoom screensharing in firefox
    "firefox",
    "kitty",
    "noto-fonts-emoji",
    "xdg-utils",
    # osu
    "fuse2",
    # yubikey
    "libfido2",
    "yubikey-manager",
    # documents
    "glow",
    "zathura",
    "zathura-pdf-mupdf",
    # image viewing
    "nsxiv",
    "xorg-xrdb",
    # editing
    "rustup",
    "clang",
    "npm",
    "nodejs",
    "lua-language-server",
    "go",
    "gopls",
    "pyright",
    "marksman",
    # audio
    "pipewire",
    "pipewire-alsa",
    "pipewire-pulse",
    "wireplumber",
    "bluez",
    "bluez-utils",
    "noise-suppression-for-voice",
    # misc
    "pass",
    "rclone",
    "mediainfo",
    "android-tools",
    # bootstrap
    "pkg-config",  # indirect for yay packages
    "python-black",
}

YAY_PACKAGES_BASE = {"shadowsocks-rust", "xray-bin"}
YAY_PACKAGES_DESKTOP = {"hyprpicker-git", "xdg-ninja", "universal-android-debloater-bin"}


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


def pacman_packages(device: Device, log_fd: typing.IO) -> typing.Callable:
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
        pkgs = ARCH_PACKAGES_HEADLESS
        if device != Device.SERVER:
            pkgs.update(ARCH_PACKAGES_HEADLESS_EXTRA)
        if device in [Device.PC, Device.LAPTOP]:
            pkgs.update(ARCH_PACKAGES_DESKTOP)
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


def yay_packages(device: Device,log_fd: typing.IO) -> typing.Callable:
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
        if device in [Device.PC, Device.LAPTOP]:
            pkgs.update(YAY_PACKAGES_DESKTOP)
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


def hypr_paper(log_fd: typing.IO, config: Config) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result["name"] = "hypr_theme"
        linkpath = f"{os.getenv('HOME')}/.config/hypr/black/hyprpaper.conf"
        targetpath = f"{os.getenv('HOME')}/.config/yadm/conf/{config.installation.value}/{config.device.value}/hyprpaper.conf"
        link_res, link_changes = setup_link(log_fd, targetpath, linkpath)
        if link_res:
            result["changes"].extend(link_changes)
        result["result"] = True
        return result

    return run


def hypr_external_config(log_fd: typing.IO, config: Config) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result["name"] = "hypr_external_config"
        linkpath = f"{os.getenv('HOME')}/.config/hypr/hyprland_external.conf"
        targetpath = f"{os.getenv('HOME')}/.config/yadm/conf/{config.installation.value}/{config.device.value}/hyprland_external.conf"
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

WIREGUARD_CLIENT_TEMPLATE = '''[Interface]
PrivateKey = {0}
Address = 10.0.0.{1}
DNS = 1.1.1.1

[Peer]
PublicKey = {2}
Endpoint = {3}
AllowedIPs = 0.0.0.0/0, ::/0
PersistentKeepalive = 25
'''

WIREGUARD_CLIENT_TEMPLATE1 = '''[Interface]
PrivateKey = {privateKey}
Address = 10.0.0.{wgNode}
DNS = 1.1.1.1
PreUp = ip route add {serverAddress}/32 via 192.168.0.1 dev {dev}
PostDown = ip route del {serverAddress}/32 via 192.168.0.1 dev {dev}

[Peer]
PublicKey = {serverWgPubkey}
Endpoint = 127.0.0.1:{wgPort}
AllowedIPs = 0.0.0.0/0, ::/0
PersistentKeepalive = 25
'''

def wireguard(config: Config, log_fd: typing.IO) -> typing.Callable:
    def ip_forward(result: dict) -> bool:
        if os.system("grep -q ip_forward /etc/sysctl.d/99-sysctl.conf"):
            if subprocess.run(
                ["sudo", "bash", "-c", "echo net.ipv4.ip_forward=1 >> /etc/sysctl.d/99-sysctl.conf; sysctl --system"],
                stdout=log_fd,
                stderr=log_fd,
            ).returncode:
                return False
            result["changes"].append("enabled ipv4 forwarding")
        return True

    def gen_keys(result: dict) -> bool:
        if subprocess.run("stat /etc/wireguard/privatekey".split(), stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL).returncode != 0:
            if subprocess.run(
                ["sudo", "bash", "-c", "wg genkey | tee /etc/wireguard/privatekey | wg pubkey > /etc/wireguard/publickey"],
                stdout=log_fd,
                stderr=log_fd,
            ).returncode:
                return False
            result["changes"].append("generated wireguard keys")
        return True

    def get_privkey() -> str:
        return subprocess.run("sudo cat /etc/wireguard/privatekey".split(), stdout=subprocess.PIPE).stdout.decode("utf-8").strip()

    def get_dev() -> str:
        return subprocess.run(['bash', '-c', "ip link | grep 'state UP' | awk '{print $2}'"], stdout=subprocess.PIPE).stdout.decode("utf-8").strip().strip(':')

    def create_wg1_file(result) -> bool:
        if os.system("stat /etc/wireguard/wg1.conf 2> /dev/null > /dev/null") == 0:
            # Kostyl to remove sudo call
            return True
        privkey = get_privkey()
        if config.secrets.wgPort is None:
            result['skipped'] = True
            return False
        wg1config = WIREGUARD_CLIENT_TEMPLATE1.format(privateKey=privkey, wgNode=config.secrets.wgNode, serverAddress=config.secrets.serverAddress, serverWgPubkey=config.secrets.serverWgPubkey, wgPort=config.secrets.wgPort, dev=get_dev())
        return utils.create_file(result, log_fd, "/etc/wireguard/wg1.conf", wg1config)

    def run() -> dict:
        result = default_result()
        result["name"] = "wireguard"
        if not utils.chmod(result, log_fd, "/etc/wireguard", "711"):
            return result
        if not gen_keys(result):
            return result
        if not utils.chmod(result, log_fd, "/etc/wireguard/publickey", "400"):
            return result
        if not utils.chmod(result, log_fd, "/etc/wireguard/privatekey", "400"):
            return result
        if config.device == Device.SERVER:
            if not utils.create_file(result, log_fd, "/etc/wireguard/wg0.conf", WIREGUARD_SERVER_TEMPLATE):
                return result
        else:
            if not utils.create_file(result, log_fd, "/etc/wireguard/wg0.conf", WIREGUARD_CLIENT_TEMPLATE):
                return result
            if not create_wg1_file(result):
                return result
            if not utils.chmod(result, log_fd, "/etc/wireguard/wg1.conf", "600"):
                return result
        if not utils.chmod(result, log_fd, "/etc/wireguard/wg0.conf", "600"):
            return result
        if config.device == Device.SERVER:
            if not ip_forward(result):
                return result

        result["result"] = True
        return result
    return run


XRAY_CLIENT_TEMPLATE = '''{{
    "log": {{
        "loglevel": "warning"
    }},
    "inbounds": [
        {{
            "tag": "wireguard",
            "port": {0},
            "protocol": "dokodemo-door",
            "settings": {{
                "address":"127.0.0.1",
                "port": {0},
                "network":"udp"
            }}
        }}
    ],
    "outbounds": [
        {{
            "protocol": "vless",
            "settings": {{
                "vnext": [
                    {{
                        "address": "{1}",
                        "port": 443,
                        "users": [
                            {{
                                "id": "{2}",
                                "encryption": "none",
                                "flow": ""
                            }}
                        ]
                    }}
                ]
            }},
            "streamSettings": {{
                "network": "h2",
                "security": "reality",
                "realitySettings": {{
                    "show": false,
                    "fingerprint": "chrome",
                    "serverName": "www.lovelive-anime.jp",
                    "publicKey": "{3}",
                    "shortId": "{4}",
                    "spiderX": ""
                }}
            }},
            "tag": "proxy"
        }}
    ]
}}
'''


def xray(log_fd: typing.IO, secrets: Secrets) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result["name"] = "xray"
        if not utils.chmod(result, log_fd, "/etc/xray", "711"):
            return result
        if os.system("stat /etc/xray/wg1.json 2> /dev/null > /dev/null") != 0:
            if secrets.wgPort is None:
                result['skipped'] = True
                return result
            xray_config = XRAY_CLIENT_TEMPLATE.format(secrets.wgPort, secrets.serverAddress, uuid.uuid4(), secrets.serverXrayPubkey, secrets.serverXrayId)
            if not utils.create_file(result, log_fd, "/etc/xray/wg1.json", xray_config):
                return result
        if not utils.chown(result, log_fd, "/etc/xray/wg1.json", "xray"):
            return result
        if not utils.chmod(result, log_fd, "/etc/xray/wg1.json", "400"):
            return result
        if not utils.enable_service(result, log_fd, 'xray@wg1'):
            return result
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


FILES_MKINITCPIO = "FILES=(\\/home\\/er\\/.config\\/kbd\\/dvp_modified \\/usr\\/share\\/kbd\\/keymaps\\/i386\\/dvorak\\/dvorak-programmer.map.gz \\/usr\\/share\\/kbd\\/keymaps\\/i386\\/include\\/linux-keys-bare.inc \\/usr\\/share\\/kbd\\/keymaps\\/i386\\/include\\/linux-with-two-alt-keys.inc)"


def vconsole(log_fd: typing.IO) -> typing.Callable:
    def run() -> dict:
        result = default_result()
        result["name"] = "mkinitcpio"
        retcode = subprocess.run(
            "grep dvp_modified /etc/vconsole.conf".split(),
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        ).returncode
        if retcode == 1:
            if subprocess.run(
                ["sudo",  "bash", "-c", "echo KEYMAP=/home/er/.config/kbd/dvp_modified > /etc/vconsole.conf"], stdout=log_fd, stderr=log_fd
            ).returncode:
                return result
            result["changes"].append("modified /etc/vconsole.conf")
        elif retcode != 0:
            return result

        retcode = subprocess.run(
            "grep dvp_modified /etc/mkinitcpio.conf".split(),
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        ).returncode
        if retcode == 1:
            if subprocess.run(
                ["sudo",  "sed",  "-i", f"s/FILES=.*/{FILES_MKINITCPIO}/", "/etc/mkinitcpio.conf"], stdout=log_fd, stderr=log_fd
            ).returncode:
                return result
            if subprocess.run(
                "sudo mkinitcpio -P".split(), stdout=log_fd, stderr=log_fd
            ).returncode:
                return result
            result["changes"].append("added vconsole keymap files to initram")
        elif retcode != 0:
            return result
        result["result"] = True
        return result
    return run
