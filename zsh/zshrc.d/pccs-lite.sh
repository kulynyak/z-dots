#!/bin/zsh

HOMEBREW_PREFIX=$(brew --prefix)

[ -d "$HOMEBREW_PREFIX/opt/pcsc-lite/bin" ] && export PATH="$HOMEBREW_PREFIX/opt/pcsc-lite/bin:$PATH"

[ -d "$HOMEBREW_PREFIX/opt/pcsc-lite/sbin" ] && export PATH="$HOMEBREW_PREFIX/opt/pcsc-lite/sbin:$PATH"

[ -d "$HOMEBREW_PREFIX/opt/pcsc-lite/lib" ] && export LDFLAGS="-L$HOMEBREW_PREFIX/opt/pcsc-lite/lib"

unset HOMEBREW_PREFIX
