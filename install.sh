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
echo "OS is $__OS"

case $__OS in
  Darwin)
    if [[ -f ./macos.sh ]]; then
      ./macos.sh
    else
      echo "Error: macos.sh script not found."
      exit 1
    fi
    ;;
  Fedora)
    if [[ -f ./fedora.sh ]]; then
      ./fedora.sh
    else
      echo "Error: fedora.sh script not found."
      exit 1
    fi
    ;;
  *)
    echo "Unsupported operating system."
    exit 1
    ;;
esac
