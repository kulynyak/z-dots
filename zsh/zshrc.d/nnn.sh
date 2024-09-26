#!/bin/zsh


# Check if nnn is installed and exit if not
command -v nnn &> /dev/null || return

# nnn aliases
alias n='NNN_COLORS="#5251d0be;2341" PAGER="less -Ri" NVIM_APPNAME=LazyVim EDITOR="nvim" VISUAL="" nnn -cdEFnQrux'

# nnn
[[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/nnn/nnn.zsh" ]] && source "${XDG_CONFIG_HOME:-$HOME/.config}/nnn/nnn.zsh"

# Optional: Uncomment if you want to use the nnn_cd function
# function nnn_cd() {
#     if [[ -n "$NNN_PIPE" ]]; then
#         printf "%s\0" "0c${PWD}" > "${NNN_PIPE}" &!
#     fi
# }
#
# trap 'nnn_cd' EXIT

# Optional: Uncomment the following alias if you want to use it
# alias n='PAGER="less -Ri" NVIM_APPNAME=LazyVim EDITOR="nvim" VISUAL="" nnn -deHr'
# export NNN_FIFO=/tmp/nnn.fifo
# export NNN_PLUG='p:preview-tui;'
