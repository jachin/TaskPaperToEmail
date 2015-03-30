echo "
=== Notices ===

    Upcoming vacation - Going to Europe. Leaving in the evening of March 30th. Getting back late on April 11th. Back in the office April 13th.

=== Completed ===

 - MN Dental
     - T9 Changing how CE Track Handles Password
         - Fixing broken selects on course setup screens
         - Fixing the dentists profile updates from CE track profile updates

=== Working on Today ===

 - Clockwork
     - Logging hours
     - branches/dev
         - Ticket #2973
             - Escape single quotes in values in prod_mgr
             - Add unit test for rendering empty config.local.php values and testing to make sure the result is valid PHP
     - branches/dev bugs
         - bring old screens that were generated using BTO up to date
             - ACE
                 - htdocs/ace/pay_per_view_video_logs.php
                 - htdocs/ace/promotion_codes.php
                 - htdocs/ace/dealers.php
 - MN Dental
     - T9 Changing how CE Track Handles Password
         - Testing
         - Code Review

=== Coming Up ===

 - MN Dental
     - review revised dev plan
     - T2 Dentist Cleanup Script
 - CT Lotter (GTech Tools)
     - Encrypting Password
 - Clockwork
     - branches/dev bugs
         - bring old screens that were generated usting BTO up to date
" | /usr/bin/env python -c "
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

            indent_len = len( indent )

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

msg = sys.stdin.read()

print(wrap(msg, 78)).encode('utf-8')"