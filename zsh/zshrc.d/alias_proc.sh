#!/bin/zsh

# Alias to search for a process by name, using -f to match against the full command line, not just the command name.
alias pgrep='pgrep -f'

# Alias to forcefully (with -9) kill processes by name, using -f to match against the full command line, not just the command name.
alias pkill='pkill -9 -f'
