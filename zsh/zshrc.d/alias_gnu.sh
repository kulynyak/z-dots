#!/bin/zsh

case "$__OS" in
Darwin)
  # Alias GNU sed as sed
  alias sed='gsed'
  # Alias GNU cat as cat
  alias cat='gcat'
  # Alias GNU head as head
  alias head='ghead'
  # Alias GNU zcat as zcat
  alias zcat='gzcat'
  ;;
Fedora) ;;
esac
