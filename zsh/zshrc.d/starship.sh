#!/bin/zsh

command -v starship &>/dev/null || return

eval "$(starship init zsh)"
