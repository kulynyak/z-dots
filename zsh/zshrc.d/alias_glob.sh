#!/bin/zsh

# Function to expand global aliases
globalias() {
	# Check if the last buffer in LBUFFER contains an uppercase word followed by space
	if [[ $LBUFFER =~ ' [A-Z0-9]+$' ]]; then
		zle _expand_alias # Expand the alias
		zle expand-word   # Expand the word
	fi
	zle self-insert # Execute standard self-insert
}

# Bind the function globalias to the space key
zle -N globalias
bindkey " " globalias

# Map control-space to bypass completion behavior
bindkey "^ " magic-space

# Define a separate mapping for normal space during searches
bindkey -M isearch " " magic-space

# Define global aliases for common command sequences
alias -g G='|& grep -E -i'           # Case-insensitive grep with extended regex
alias -g L="| less"                  # Pipe output to less
alias -g X='| xargs'                 # Pipe output to xargs
alias -g X0='| xargs -0'             # Pipe output to xargs with null-terminated strings
alias -g C='| wc -l'                 # Count lines in the output
alias -g A='| awk'                   # Process output using awk
alias -g H='| head -n $(($LINES-5))' # Show top part of output leaving some lines for screen usage
alias -g T='| tail -n $(($LINES-5))' # Show bottom part of output leaving some lines for screen usage
alias -g S='| sed'                   # Process output using sed
alias -g N='&> /dev/null'            # Redirect all output to /dev/null
alias -g B='| pbcopy'                # Copy output to clipboard
alias -g NF="./*(oc[1])"             # Get the last modified (inode time) file or directory
