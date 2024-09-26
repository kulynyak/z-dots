#!/bin/zsh

CARGO_PATH="$HOME/.cargo"
[[ -d $CARGO_PATH ]] && source "$CARGO_PATH/env"
unset CARGO_PATH
