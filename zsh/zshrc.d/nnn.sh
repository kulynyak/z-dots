#!/bin/zsh

# function nnn_cd() {
#     if [[ -n "$NNN_PIPE" ]]; then
#         printf "%s\0" "0c${PWD}" > "${NNN_PIPE}" &!
#     fi
# }
#
# trap 'nnn_cd' EXIT

# alias n='PAGER="less -Ri" NVIM_APPNAME=LazyVim EDITOR="nvim" VISUAL="" nnn -deHr'
alias n='NNN_COLORS="#5251d0be;2341" PAGER="less -Ri" NVIM_APPNAME=LazyVim EDITOR="nvim" VISUAL="" nnn -cdEFnQrux'

# export NNN_FIFO=/tmp/nnn.fifo
# export NNN_PLUG='p:preview-tui;'
