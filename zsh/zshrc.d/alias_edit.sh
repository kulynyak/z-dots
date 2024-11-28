#!/bin/zsh

if command -v nvim >/dev/null 2>&1; then
    editor() {
        NVIM_APPNAME=LazyVim nvim "$@"
    }
    export EDITOR='editor'
    export VISUAL='editor'
fi
# Set alias for the editor
alias vi='$EDITOR'
alias vim='$EDITOR'
alias svi='sudo $EDITOR'
alias snano='sudo nano'
