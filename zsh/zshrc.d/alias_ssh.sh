#!/bin/zsh

function sshlist() {
  # about 'list hosts defined in ssh config'
  awk '$1 ~ /Host$/ {for (i=2; i<=NF; i++) print $i}' ~/.ssh/config
}

function setup_ssh_agent() {
  # about 'initialize and configures ssh-agent'
  if (($ + commands[ssh - agent])); then
    # Set the path to the SSH directory.
    _ssh_dir="$HOME/.ssh"
    # Set the path to the environment file if not set by another module.
    _ssh_agent_env="${_ssh_agent_env:-${XDG_CACHE_HOME:-$HOME/.cache}/$USER/ssh-agent.env}"
    # Set the path to the persistent authentication socket.
    _ssh_agent_sock="${XDG_CACHE_HOME:-$HOME/.cache}/$USER/ssh-agent.sock"
    # Start ssh-agent if not started.
    if [[ ! -S "$SSH_AUTH_SOCK" ]]; then
      # Export environment variables.
      source "$_ssh_agent_env" 2>/dev/null
      # Start ssh-agent if not started.
      if ! ps -U "$LOGNAME" -o pid,ucomm | grep -q -- "${SSH_AGENT_PID:--1} ssh-agent"; then
        mkdir -p "$_ssh_agent_env:h"
        eval "$(ssh-agent | sed '/^echo /d' | tee "$_ssh_agent_env")"
      fi
    fi
    # Create a persistent SSH authentication socket.
    if [[ -S "$SSH_AUTH_SOCK" && "$SSH_AUTH_SOCK" != "$_ssh_agent_sock" ]]; then
      mkdir -p "$_ssh_agent_sock:h"
      ln -sf "$SSH_AUTH_SOCK" "$_ssh_agent_sock"
      export SSH_AUTH_SOCK="$_ssh_agent_sock"
    fi
    # Load identities.
    if ssh-add -l 2>&1 | grep -q 'The agent has no identities'; then
      # ssh-add has strange requirements for running SSH_ASKPASS, so we
      # duplicate them here. Essentially, if the other requirements are met,
      # we redirect stdin from /dev/null in order to meet the final requirement.
      #
      # From ssh-add(1):
      # If ssh-add needs a passphrase, it will read the passphrase from the
      # current terminal if it was run from a terminal. If ssh-add does not
      # have a terminal associated with it but DISPLAY and SSH_ASKPASS are set,
      # it will execute the program specified by SSH_ASKPASS and open an X11
      # window to read the passphrase.
      if [[ -n "$DISPLAY" && -x "$SSH_ASKPASS" ]]; then
        ssh-add ${_ssh_identities:+$_ssh_dir/${_ssh_identities[@]}} </dev/null 2>/dev/null
      else
        if (($ + commands[ssh - add])); then
          ssh-add ${_ssh_identities:+$_ssh_dir/${_ssh_identities[@]}} 2>/dev/null
        else
          echo "ssh-add command not found."
        fi
      fi
    fi
    # Clean up.
    unset _ssh_{dir,identities} _ssh_agent_{env,sock}
  fi
}

# Run the function to setup SSH agent
setup_ssh_agent
