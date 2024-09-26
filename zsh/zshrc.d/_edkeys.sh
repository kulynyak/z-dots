#!/bin/zsh

# Move to the beginning of the line (triggered by <Home> or <Fn + Left Arrow>)
bindkey "^[OH" beginning-of-line

# Move to the beginning of the line (another variant of <Home> or <Fn + Left Arrow>)
bindkey "^[[H" beginning-of-line

# Move to the end of the line (triggered by <End> or <Fn + Right Arrow>)
bindkey "^[OF" end-of-line

# Move to the end of the line (another variant of <End> or <Fn + Right Arrow>)
bindkey "^[[F" end-of-line

# Move cursor forward by one word (triggered by <Alt + Right Arrow>)
bindkey '^[[1;3C' forward-word

# Move cursor forward by one word (triggered by <Right Arrow>)
bindkey '^[[C' forward-word

# Move cursor backward by one word (triggered by <Alt + Left Arrow>)
bindkey '^[[1;3D' backward-word

# Move cursor backward by one word (triggered by <Left Arrow>)
bindkey '^[[D' backward-word

# Move cursor forward by one character (another variant of <Right Arrow>, please review)
bindkey '^[[C' forward-char

# Move cursor backward by one character (another variant of <Left Arrow>, please review)
bindkey '^[[D' backward-char

# Delete the character before the cursor (triggered by <Backspace> or <Delete>)
bindkey '^?' backward-delete-char

# Delete the character under the cursor (triggered by <Delete>)
bindkey "^[[3~" delete-char

# Delete the character under the cursor (special combination, review based on your setup)
bindkey "^[3;5~" delete-char

# Delete the word under the cursor (triggered by <Ctrl + Fn + Delete>)
bindkey '^[[3;5~' delete-word

# Delete the word before the cursor (triggered by <Ctrl + Delete>)
bindkey '^H' backward-delete-word

# Bind space key during searches to act as a "magic-space"
bindkey -M isearch " " magic-space

# Clear the entire screen (triggered by <Ctrl + X>)
bindkey '^X' clear-screen

# Edit the current command line using the default editor specified by $EDITOR
autoload -U edit-command-line
zle -N edit-command-line

# Edit the command line (triggered by <Ctrl + X> followed by <Ctrl + E>)
bindkey '^X^E' edit-command-line

# Accept a menu selection and complete the command (space key during menu selection)
# bindkey -M menuselect " " accept-and-menu-complete
