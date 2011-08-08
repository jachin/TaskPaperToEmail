tell application "TaskPaper"
	tell front document
		my proccess_exported_text(export with entries entries)
	end tell
end tell

on proccess_exported_text(exported_text)
	--Format Message
	
	--set exported_text to ReplaceText(exported_text, "\r", "\n")
	set CRLF to ((ASCII character 13) & (ASCII character 10))
	set LF to ASCII character 10
	set CR to ASCII character 13
	set exported_text to replace_chars(exported_text, CRLF, LF)
	set exported_text to replace_chars(exported_text, CR, LF)
	
	-- Handle Headings
	set sed_format_projects to "sed 's/^\\([[:alnum:]][[:alnum:][:blank:]]*\\):$/=== \\1 ===/'"
	set the_command_string to "echo " & quoted form of exported_text & " | " & sed_format_projects
	set exported_text to do shell script the_command_string
	
	-- Switch to unix new lines
	set exported_text to replace_chars(exported_text, CRLF, LF)
	set exported_text to replace_chars(exported_text, CR, LF)
	
	-- Add new lines around 'Projects'
	set sed_format to "sed 's/^=== .* ===$/\\
&\\
/'"
	set the_command_string to "echo " & quoted form of exported_text & " | " & sed_format
	set exported_text to do shell script the_command_string
	
	-- Switch to unix new lines
	set exported_text to replace_chars(exported_text, CRLF, LF)
	set exported_text to replace_chars(exported_text, CR, LF)
	
	-- Replace tabs with spaces
	set sed_format to "sed 's/	/    /g'"
	set the_command_string to "echo " & quoted form of exported_text & " | " & sed_format
	set exported_text to do shell script the_command_string
	
	-- Switch to unix new lines
	set exported_text to replace_chars(exported_text, CRLF, LF)
	set exported_text to replace_chars(exported_text, CR, LF)
	
	-- Add an extra spance in front of all the lines that start with a dash (tasks)
	set sed_command to "sed 's/^[[:blank:]]*-.*$/ &/'"
	set the_command_string to "echo " & quoted form of exported_text & " | " & sed_command
	set exported_text to do shell script the_command_string
	
	-- Switch to unix new lines
	set exported_text to replace_chars(exported_text, CRLF, LF)
	set exported_text to replace_chars(exported_text, CR, LF)
	
	-- Wrap Text
	set python_script to "
import re
import sys

def wrap(text, width):

	pattern = re.compile('^([\s\-]*)(.+$)')

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

print(wrap(msg, 78)).encode('utf-8')
"
	
	set the_command_string to "echo \"" & exported_text & "\" | /usr/bin/env python -c \"" & python_script & "\""
	set exported_text to do shell script the_command_string
	
	-- Switch to unix new lines
	set exported_text to replace_chars(exported_text, CRLF, LF)
	set exported_text to replace_chars(exported_text, CR, LF)
	
	-- Dump export text
	--set the_command_string to "echo " & quoted form of exported_text & " > ~/Desktop/snap.txt"
	--do shell script the_command_string
	--return exported_text
	
	-- Send the snapshot to a new mail nessage
	tell application "Mail"
		set newMessage to make new outgoing message with properties {subject:"my subject", content:exported_text}
		tell newMessage
			set visible to true
			make new to recipient at end of to recipients with properties {name:"Some Body", address:"who@where.com"}
		end tell
	end tell
	-- Make message plain text
	tell application "System Events"
		tell application "Mail" to activate
		keystroke "t" using {command down, shift down}
	end tell
end proccess_exported_text

on replace_chars(this_text, search_string, replacement_string)
	set AppleScript's text item delimiters to the search_string
	set the item_list to every text item of this_text
	set AppleScript's text item delimiters to the replacement_string
	set this_text to the item_list as string
	set AppleScript's text item delimiters to ""
	return this_text
end replace_chars

