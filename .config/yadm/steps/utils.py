import os
import typing


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
