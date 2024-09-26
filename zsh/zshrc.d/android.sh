#!/bin/zsh

# Set ANDROID_HOME based on the operating system
case "$__OS" in
Darwin)
  ANDROID_HOME="$HOME/Library/Android/sdk"
  ;;
Fedora)
  # Optionally set ANDROID_HOME for Fedora or leave it empty
  ANDROID_HOME="" # or set it accordingly
  ;;
*)
  # Handle other OS cases or do nothing
  ANDROID_HOME=""
  ;;
esac

# If ANDROID_HOME is set and the directory exists, update the PATH
[[ -d $ANDROID_HOME ]] && {
  export ANDROID_HOME
  PATH="$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools/bin:$PATH"
}
