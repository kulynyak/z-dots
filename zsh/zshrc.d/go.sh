#!/bin/zsh


command -v go &>/dev/null || return

# Set Go environment variables
export GOROOT="$(brew --prefix go)/libexec"
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH="$GOPATH:$GOBIN:$PATH"
