#!/bin/zsh

# Determine the installation path for fzf based on the OS
case "$__OS" in
Darwin)
  FZF_SHELL=$(brew --prefix)/opt/fzf/shell
  ;;
Fedora)
  FZF_SHELL=/usr/share/fzf/shell
  ;;
esac

# Check if fzf is installed by verifying the directories exist
[[ -d "$FZF_SHELL" ]] || {
  unset FZF_SHELL
  return
}

# Setup fzf auto-completion if the file exists
[[ -f "$FZF_SHELL/completion.zsh" ]] && source "$FZF_SHELL/completion.zsh" 2>/dev/null

# Setup fzf key bindings if the file exists
[[ -f "$FZF_SHELL/key-bindings.zsh" ]] && source "$FZF_SHELL/key-bindings.zsh" 2>/dev/null

unset FZF_SHELL
