#!/usr/bin/env bash

__OS=unsupported
case $(uname) in
Darwin)
	export __OS=Darwin
	;;
Linux)
	[[ -f /etc/fedora-release ]] && export __OS=Fedora
	;;
esac
export __OS

case $__OS in
Darwin)
  brew install --cask finicky
	;;
Fedora)
  return 0
	;;
esac

# ln -sfn "$PWD/finicky.js" "$HOME/.finicky.js"
ln -fn "$PWD/finicky.js" "$HOME/.finicky.js"
