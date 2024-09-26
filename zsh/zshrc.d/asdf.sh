#!/bin/zsh

case "$__OS" in
Darwin)
  ASDF_LIB="$(brew --prefix asdf)/libexec"
  ;;
Fedora)
  ASDF_LIB="$HOME/.asdf"
  ;;
esac
[[ -d $ASDF_LIB ]] && source "$ASDF_LIB/asdf.sh"
unset ASDF_LIB
