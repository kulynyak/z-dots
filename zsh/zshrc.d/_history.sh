#!/bin/zsh

# History configuration
HISTFILE="$HOME/.zsh_history"    # File where the command history is saved
HISTSIZE=50000                   # Number of commands to remember in the history
SAVEHIST=10000                   # Number of commands to save in the history file

# History command options
setopt extended_history       # Record timestamp of command in HISTFILE
setopt hist_expire_dups_first # Delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # Ignore duplicated commands history list
setopt hist_ignore_all_dups   # Ignore all previous duplicated commands in history list
setopt hist_ignore_space      # Ignore commands that start with space
setopt hist_verify            # Show command with history expansion to user before running it
setopt share_history          # Share command history data
setopt hist_find_no_dups      # Do not display a command in search if it is identical to subsequent one
setopt hist_save_no_dups      # Do not save the command to HISTFILE if it is a duplicate
setopt hist_beep              # Beep when hist expansion fails

# Custom history command wrapper
function omz_history {
  local clear list
  zparseopts -E c=clear l=list
  if [[ -n "$clear" ]]; then
    echo -n >| "$HISTFILE"
    fc -p "$HISTFILE"
    echo >&2 History file deleted.
  elif [[ -n "$list" ]]; then
    builtin fc "$@"
  else
    [[ ${@[-1]} == *[0-9]* ]] && builtin fc -l "$@" || builtin fc -l "$@" 1
  fi
}

# Timestamp format alias for history command
case ${HIST_STAMPS-} in
  "mm/dd/yyyy") alias history='omz_history -f' ;;
  "dd.mm.yyyy") alias history='omz_history -E' ;;
  "yyyy-mm-dd") alias history='omz_history -i' ;;
  "") alias history='omz_history' ;;
  *) alias history="omz_history -t '$HIST_STAMPS'" ;;
esac

# Alias for listing history
alias hist='fc -l 1'

# Pattern to ignore specific commands in history
HISTORY_IGNORE='(z|cd ..|l|l[alsh]|less|lvim|nvim|vi|vim|hx|n|nnn|x|q|exit|zreload)'

# Key bindings for history navigation
bindkey "^[[5~" up-line-or-history   # <Page Up>
bindkey "^[[6~" down-line-or-history # <Page Down>


# Determine the location of ZSH-related files based on the operating system
case "$__OS" in
    Darwin)
        ZSH_STUFF=$(brew --prefix)/share  # On macOS, use Homebrew's share directory
        ;;
    Fedora)
        ZSH_STUFF=/usr/share  # On Fedora, use the system's share directory
        ;;
esac

# Load zsh syntax highlighting if the file exists
[[ -f "$ZSH_STUFF/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && source $ZSH_STUFF/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Load zsh autosuggestions if the file exists; otherwise, exit with error code 1
[[ -f "$ZSH_STUFF/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && source $ZSH_STUFF/zsh-autosuggestions/zsh-autosuggestions.zsh || return 1

# Set the highlight color for autosuggestions, default is 'fg=8'
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

# Configure key bindings for vi mode if key_info is provided
if [[ -n "$key_info" ]]; then
    bindkey -M viins "$key_info[Control]F" vi-forward-word  # Bind Control+F to move forward one word
    bindkey -M viins "$key_info[Control]E" vi-add-eol       # Bind Control+E to move to the end of the line
fi

# History substring search
[[ -f "$ZSH_STUFF/zsh-history-substring-search/zsh-history-substring-search.zsh" ]] && source "$ZSH_STUFF/zsh-history-substring-search/zsh-history-substring-search.zsh"

unset ZSH_STUFF

bindkey '^[[A' history-substring-search-up       # <Up Arrow>
bindkey '^[[B' history-substring-search-down     # <Down Arrow>
# bindkey '^R' history-incremental-search-backward # <Ctrl+R>
