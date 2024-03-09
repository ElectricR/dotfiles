import os
import typing
import subprocess


def default_result():
    return {"name": "CHANGE ME", "result": False, "skipped": False, "changes": []}


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


def chown(result: dict, log_fd: typing.IO, path: str, user: str) -> bool:
    if subprocess.run(['bash', '-c', f'test "$(stat -c %U {path})" = {user}'], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL).returncode != 0:
        if subprocess.run(
            f"sudo chown {user} {path}".split(),
            stdout=log_fd,
            stderr=log_fd,
        ).returncode:
            return False
        result["changes"].append(f"changed user for {path} to {user}")
    return True


def create_file(result: dict, log_fd: typing.IO, path: str, content: str) -> bool:
    if subprocess.run(f"stat {path}".split(), stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL).returncode != 0:
        p = subprocess.Popen(
            ["sudo", "bash", "-c", f"cat > {path}"],
            stdin=subprocess.PIPE,
            stdout=log_fd,
            stderr=log_fd,
        )
        p.communicate(bytes(content, 'utf-8'))
        if p.returncode != 0:
            return False
        result["changes"].append(f"created file at {path}")
    return True


def enable_service(result: dict, log_fd: typing.IO, service: str) -> bool:
    retcode = subprocess.run(
        f"systemctl is-enabled {service}".split(),
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    ).returncode
    if retcode == 1:
        if subprocess.run(
            f"sudo systemctl enable --now {service}".split(), stdout=log_fd, stderr=log_fd
        ).returncode:
            return False
        result["changes"].append(f"{service} service has been enabled")
    elif retcode != 0:
        return False
    return True
