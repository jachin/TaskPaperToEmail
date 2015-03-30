#!/usr/bin/env python

import subprocess
import sys

script = """tell application "TaskPaper"
    tell front document
        my proccess_exported_text(export with entries entries)
    end tell
end tell

on proccess_exported_text(exported_text)
    exported_text
end proccess_exported_text
"""


def make_headings(content):

    # Handle Headings
    p = subprocess.Popen(
        ['sed', 's/^\\([[:alnum:]][[:alnum:][:blank:]]*\\):$/=== \\1 ===/'],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE
    )

    content, stderr = p.communicate(content)

    # Add new lines around 'Projects'
    p = subprocess.Popen(
        ['sed', 's/^=== .* ===$/\\\n&\\\n/'],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE
    )

    content, stderr = p.communicate(content)

    # Replace tabs with spaces
    p = subprocess.Popen(
        ['sed', 's/\t/    /g'],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE
    )

    content, stderr = p.communicate(content)

    # Add an extra spance in front of all the lines that start with a
    #  dash (tasks)
    p = subprocess.Popen(
        ['sed', 's/^[[:blank:]]*-.*$/ &/'],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE
    )

    content, stderr = p.communicate(content)

    return content


def get_open_task_paper_doc_as_text():

    p = subprocess.Popen(
        ['/usr/bin/osascript', '-'],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE
    )

    stdout, stderr = p.communicate(script)

    if p.returncode != 0:
        print(stderr)
        sys.exit(p.returncode)

    content = make_headings(stdout)
    return content


if __name__ == "__main__":
    content = get_open_task_paper_doc_as_text()
    print(content)
