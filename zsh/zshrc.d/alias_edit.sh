#!/bin/zsh

# Check if nvim is installed
if command -v nvim >/dev/null 2>&1; then
  export EDITOR='nvim'
  export VISUAL='nvim'
fi

# Set alias for the editor
alias vi='$EDITOR'
alias vim='$EDITOR'
alias svi='sudo $EDITOR'
alias snano='sudo nano'
