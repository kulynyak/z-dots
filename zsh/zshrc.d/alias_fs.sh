#!/bin/zsh

alias dsize='du -s *(/)' # show directories size

alias rm='trash'

alias ll='ls -la' # Lists in one column, hidden files.
alias l='ls -l'   # Lists in one column.

alias pyshare='python3 -m http.server' # share current folder

function pfd {
  # about 'displays the current Finder.app directory'
  # Uses AppleScript to get Finder's current directory
  osascript 2>/dev/null <<EOF
    tell application "Finder"
      return POSIX path of (target of first window as text)
    end tell
EOF
}

function pfs {
  # about 'displays the current Finder.app selection'
  # Uses AppleScript to get the currently selected items in Finder
  osascript 2>&1 <<EOF
    tell application "Finder" to set the_selection to selection
    if the_selection is not {}
      repeat with an_item in the_selection
        log POSIX path of (an_item as text)
      end repeat
    end if
EOF
}

function ql {
  # about 'previews files in Quick Look'
  # '$#': check the number of arguments
  # 'qlmanage -p': open files in Quick Look
  if (($# > 0)); then
    qlmanage -p "$@" &>/dev/null
  fi
}

function bkpf() {
  # about 'back up file with timestamp'
  # param 'filename'
  # example '$ bkpf ~/.zshrc'
  # Creates a copy of the file with a timestamp appended to the filename
  local filename=$1
  local filetime=$(date +%Y-%m-%d-%H-%M-%S)
  cp -a "${filename}" "${filename}-${filetime}"
}

function lsgrep() {
  # about 'search through directory contents with grep'
  # List all files in long format using 'gls -l'
  # Pass the output to 'grep'
  # 'grep -E': Use extended regular expressions
  # 'grep -i': Perform case-insensitive matching
  # '$*': Search for the provided pattern(s)
  gls -l | grep -E -i "$*"
}

function catt() {
  # about 'display whatever file is regular file or folder'
  # param 'target file or dir'
  # example '$ catt ~/.zshrc'
  for i in "$@"; do
    if [ -d "$i" ]; then
      ll "$i"
    else
      cat "$i"
    fi
  done
}
