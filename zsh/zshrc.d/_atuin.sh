#!/bin/zsh

# Bind ctrl-r but not up arrow
command -v atuin &>/dev/null || return

eval "$(atuin init zsh --disable-up-arrow)"
