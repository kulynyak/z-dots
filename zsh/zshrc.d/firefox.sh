#!/bin/zsh

# Check if Firefox is installed and set the environment variable if it is
command -v firefox &>/dev/null || return

export MOZ_DISABLE_SAFE_MODE_KEY="never"
