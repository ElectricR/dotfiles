#!/usr/bin/env python

import sys
import subprocess


PRIORITY_VALUES = ["VL", "L", "", "M", "H"]


def get_prefix(url: str) -> str:
    if url.startswith("https://www.youtube.com"):
        return 'Watch video'
    return 'Read article'


def main():
    url = sys.argv[1]
    bookmark_title = sys.argv[2]
    priority = input("Priority? ")
    if priority not in PRIORITY_VALUES:
        print(f"Priority {priority} is not valid")
        return
    tag = input("Tag? ")
    if len(tag.split()) != 1:
        print(f"Tag {tag} is not valid")
        return
    task_prefix = get_prefix(url)
    p = subprocess.run(["task", "add", f"pri:{priority}", f"+{tag}", f"{task_prefix} {bookmark_title}"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if p.returncode != 0:
        print(f"Error running task add: {p.stderr}")
        return
    task_id = p.stdout.strip()[:-1].split()[2]
    p = subprocess.run(["task", "annotate", task_id, url], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if p.returncode != 0:
        print(f"Error running task annotate for id {task_id}: {p.stderr}")
        return


if __name__ == "__main__":
    main()
