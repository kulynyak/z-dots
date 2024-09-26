#!/bin/zsh

# Function to check directory and update PATH or MANPATH
update_path() {
  local dir="$1"
  local var_name="$2"

  if [[ -d "$dir" ]]; then
    if [[ "$var_name" == "PATH" ]]; then
      PATH="$dir:$PATH"
    elif [[ "$var_name" == "MANPATH" ]]; then
      MANPATH="$dir:$MANPATH"
    fi
  fi
}

case "$__OS" in
Darwin)
  # GNU coreutils
  update_path "$(brew --prefix coreutils)/bin" "PATH"

  # GNU findutils
  update_path "$(brew --prefix findutils)/bin" "PATH"
  update_path "$(brew --prefix findutils)/libexec/gnuman" "MANPATH"

  # gettext
  GETTXT="$(brew --prefix gettext)"
  if [[ -d "$GETTXT" ]]; then
    export LDFLAGS="$LDFLAGS -L$GETTXT/lib"
    export CPPFLAGS="$CPPFLAGS -I$GETTXT/include"
    update_path "$GETTXT/bin" "PATH"
  fi

  export PATH
  export MANPATH
  ;;
*) ;;
esac

# Unset the function if needed
unset update_path
