#!/bin/zsh

# Add .NET Core SDK tools if the directory exists
DOTNET_TOOLS_DIR="/Users/ra/.dotnet/tools"
[[ -d "$DOTNET_TOOLS_DIR" ]] || return

PATH="$DOTNET_TOOLS_DIR:$PATH"
export PATH

unset DOTNET_TOOLS_DIR
