#!/bin/zsh

# z.lua is disabled by default
return

# Determine the path for z.lua based on the operating system
case "$__OS" in
Darwin)
  export Z_LUA_BIN="$(brew --prefix z.lua)/share/z.lua/z.lua" # Set the path for macOS
  ;;
Fedora)
  export Z_LUA_BIN="$HOME/.local/opt/z.lua/z.lua" # Set the path for Fedora
  ;;
esac

# Check if the z.lua binary exists
if [ -f $Z_LUA_BIN ]; then
  export _ZL_DATA=$HOME/.local/share/zlua # Data directory for z.lua
  export _ZL_ADD_ONCE=1                   # Add entries to database only once
  eval "$(lua $Z_LUA_BIN --init zsh)"     # Initialize z.lua with zsh
  alias j='z -i'                          # Jump to directory if matches found
  alias jf='z -I'                         # Jump using interactive mode
  alias zz='z -c'                         # Restrict matches to subdirectories of $PWD
  alias zi='z -i'                         # Change directory with interactive selection
  alias zf='z -I'                         # Use fzf to select in multiple matches
  alias zb='z -b'                         # Quickly change to the parent directory
fi

unset Z_LUA_BIN
