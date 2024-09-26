#!/bin/zsh

PKG_CONFIG_PATH="${PKG_CONFIG_PATH:-}"

if [ -d "/usr/local/opt/libffi/lib/pkgconfig" ]; then
  PKG_CONFIG_PATH="/usr/local/opt/libffi/lib/pkgconfig:$PKG_CONFIG_PATH"
fi

if [ -d "/usr/local/opt/libxml2/lib/pkgconfig" ]; then
  PKG_CONFIG_PATH="/usr/local/opt/libxml2/lib/pkgconfig:$PKG_CONFIG_PATH"
fi

export PKG_CONFIG_PATH="$PKG_CONFIG_PATH"
