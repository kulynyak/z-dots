#!/bin/zsh

command -v pnpm &>/dev/null || return

PNPM_GLOB_BIN="$HOME/.local/share/pnpm/g-bin"
[[ -d $PNPM_GLOB_BIN ]] && PATH="$PNPM_GLOB_BIN:$PATH"
unset PNPM_GLOB_BIN
