#!/bin/zsh

# Exit the script if the operating system is not macOS (Darwin).
[[ "$__OS" != "Darwin" ]] && return

# Alias to list the bundle identifier of an application.
# Usage example: lsbundleid "Safari.app"
alias lsbundleid="osascript -e 'on run args
set output to {}
repeat with param in args
set end of output to id of app param
end repeat
set text item delimiters to linefeed
output as text
end run'"

# Alias to display a notification using Hammerspoon.
# Usage example: ndone
alias ndone='open -g "hammerspoon://task-completed?message=Done"'

# Alias to use the "say" command to announce process completion.
# Usage example: lmk
alias lmk="say 'Process complete'"

# Alias to append a "Done" notification after a command.
# Usage example: ls D + Space
alias -g D="; ndone"

# Alias to append a "Done" notification with sound after a command.
# Usage example: ls SD + Space
alias -g SD="; ndone; lmk"
