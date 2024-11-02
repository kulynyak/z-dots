#!/bin/zsh

if [ -d "/Library/TeX/texbin" ]; then
    export PATH="/Library/TeX/texbin:$PATH"
fi
