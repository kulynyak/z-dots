#!/bin/zsh

if [ -d "/usr/local/lib/girepository-1.0" ]; then
    export GI_TYPELIB_PATH="/usr/local/lib/girepository-1.0:$GI_TYPELIB_PATH"
fi

HOMEBREW_PREFIX=$(brew --prefix)
if [ -d "Y/lib/girepository-1.0" ]; then
    export GI_TYPELIB_PATH="$HOMEBREW_PREFIX/lib/girepository-1.0:$GI_TYPELIB_PATH"
fi

unset HOMEBREW_PREFIX
