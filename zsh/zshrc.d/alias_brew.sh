#!/bin/zsh

[[ "$__OS" != "Darwin" ]] && return

# This alias dumps all Homebrew packages into a Brewfile located at $HOME/.config/u-dots/brew/Brewfile'
alias bbd='brew bundle dump --all --force --file=$HOME/.config/u-dots/brew/Brewfile'

function up-brew() {
  # about 'This function updates Homebrew packages, cleans up stale packages, removes old Homebrew-Cask symlinks, and runs brew doctor'
  brew update
  brew upgrade
  brew cleanup
  find $(brew --prefix)/Library/Homebrew -name 'homebrew-cask' -type l -exec rm -v {} +
  brew doctor
}

function up-cask() {
  # about 'This function updates outdated casks, excluding the ones that are already at their latest version'
  OUTDATED=$(brew outdated --cask --greedy --verbose | sed -E '/latest/d' | awk '{print $1}')
  if [[ -n "$OUTDATED" ]]; then
    echo "outdated: $OUTDATED"
    while IFS= read -r cask; do
      brew reinstall --cask "${cask%% *}"
    done <<< "$OUTDATED"
  fi
}

function up() {
  # about 'This function combines up-brew and up-cask to update both brew packages and outdated casks'
  up-brew
  up-cask
}
