import os
import typing
import subprocess


def default_result():
    return {"name": "CHANGE ME", "result": False, "changes": []}


def setup_link(
    log_fd: typing.IO, targetpath: str, linkpath: str
) -> typing.Tuple[bool, typing.List]:
    try:
        will_install = False
        if not os.path.islink(linkpath):
            will_install = True
        else:
            if os.readlink(linkpath) != targetpath:
                os.unlink(linkpath)
                will_install = True
        if will_install:
            os.symlink(targetpath, linkpath)
            return (True, [f"{linkpath} has been linked"])
        return (False, [])
    except Exception as e:
        log_fd.write(str(e))
        log_fd.write("\n")
        return (False, [])


def chmod(result: dict, log_fd: typing.IO, path: str, mode: str) -> bool:
    if subprocess.run(['bash', '-c', f'test "$(stat -c %a {path})" = {mode}'], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL).returncode != 0:
        if subprocess.run(
            f"sudo chmod {mode} {path}".split(),
            stdout=log_fd,
            stderr=log_fd,
        ).returncode:
            return False
        result["changes"].append(f"changed mode for {path} to {mode}")
    return True
