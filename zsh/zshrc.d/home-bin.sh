#!/bin/zsh

# Define bin in home dir
HOME_BIN="$HOME/bin"
[[ -d $HOME_BIN ]] && PATH="$HOME_BIN:$PATH"
unset HOME_BIN

# Define .local/bin in home dir
HOME_LBIN="$HOME/.local/bin"
[[ -d $HOME_LBIN ]] && PATH="$HOME_LBIN:$PATH"
unset HOME_LBIN
