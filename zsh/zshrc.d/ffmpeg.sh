#!/bin/zsh

# Check if ffmpeg is installed and exit if not
command -v ffmpeg &>/dev/null || return

alias ffprobe='sudo ffprobe -hide_banner'
alias ffplay='sudo ffplay -hide_banner'
alias ffmpeg='sudo ffmpeg -hide_banner'
