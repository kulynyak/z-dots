#!/bin/zsh

# Remove the alias for zed if it exists
unalias zed &>/dev/null || true

# Check if zed-preview is available and create an alias for zed
command -v zed-preview &>/dev/null && alias zed='zed-preview'
