#!/bin/zsh

DOCKER_PATH="/Applications/Docker.app/Contents/Resources/bin"
[[ -d $DOCKER_PATH ]] && PATH="$DOCKER_PATH:$PATH"
unset DOCKER_PATH
