#!/bin/zsh

case "$__OS" in
Darwin)
  # Check if Google Chrome exists
  if [[ -d "/Applications/Google Chrome.app" ]]; then
    alias chromed='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --remote-debugging-port=9222 &'
  fi
  ;;
Fedora) ;;
*) ;;
esac
