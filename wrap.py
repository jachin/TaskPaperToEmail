import re
import sys


def wrap(text, width):

    pattern = re.compile('^([\s\-]+)(.+$)')
    wrapped_text = ''

    for line in text.split('\n'):
        if len(line) < width:
            wrapped_text += line + '\n'
        else:
            m = pattern.match(line)

            indent = m.group(1)
            content = m.group(2)

            indent_len = len(indent)

            current_line = indent

            for word in content.split():
                if len(word) + len(current_line) + 1 > width:
                    wrapped_text += current_line + '\n'
                    current_line = ' ' * indent_len
                    current_line += ' ' + word
                else:
                    current_line += ' ' + word

            if len(current_line) > 0:
                wrapped_text += current_line + '\n'
    return wrapped_text

if __name__ == "__main__":
    msg = sys.stdin.read()
    print(wrap(msg, 78)).encode('utf-8')
