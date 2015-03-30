import re
import sys


def wrap(text, width=78):

    pattern = re.compile('^([\s\-]*)(.+$)')
    wrapped_text = ''

    for line in text.split('\n'):
        if len(line) < width:
            wrapped_text += line + '\n'
        else:
            m = pattern.match(line)

            if m is None:
                print(line)
                continue

            indent = m.group(1)
            content = m.group(2)

            indent_len = len(indent)

            current_line = indent

            for i, word in enumerate(content.split()):
                if len(word) + len(current_line) + 1 > width:
                    wrapped_text += current_line + '\n'
                    current_line = ' ' * indent_len
                    current_line += ' ' + word
                else:
                    if i is 0:
                        current_line += word
                    else:
                        current_line += ' ' + word

            if len(current_line) > 0:
                wrapped_text += current_line + '\n'
    return wrapped_text

if __name__ == "__main__":
    msg = sys.stdin.read()
    print(wrap(msg, 78)).encode('utf-8')
