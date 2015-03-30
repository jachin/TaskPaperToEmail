tell application "TaskPaper"
    tell front document
        my proccess_exported_text(export with entries entries)
    end tell
end tell

on proccess_exported_text(exported_text)
    exported_text
end proccess_exported_text
