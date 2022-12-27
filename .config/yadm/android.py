import common
import os
import os.path

ANDROID_PACKAGES = ["wget", "tmux", "taskwarrior", "tree"]

#####################
# Steps
#####################

def install_packages() -> int:
    package_manager = "pkg install"
    retcode = os.system(f"{package_manager} " + ' '.join(ANDROID_PACKAGES))
    return 2 if retcode else 0


#####################
# Main
#####################
def bootstrap():
    steps = [install_packages]
    common.bootstrap(steps)
