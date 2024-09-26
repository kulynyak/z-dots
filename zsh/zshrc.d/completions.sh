#!/bin/zsh

COMPL_PATH="$HOME/.local/share/zfunc"
[[ -d $COMPL_PATH ]] && fpath+="$COMPL_PATH"
unset COMPL_PATH
