#!/bin/zsh

# Define aliases for different NVIM_APPNAME configurations
alias ci="NVIM_APPNAME=LazyVim nvim"
alias vc="NVIM_APPNAME=NvChad nvim"
alias va="NVIM_APPNAME=AstroNvim nvim"
alias nc="NVIM_APPNAME=nCi nvim"
alias vi="NVIM_APPNAME=neoLaunch nvim"

# Helper function to extract NVIM_APPNAME values from aliases
function get_nvappnames() {
    echo "Cancel" $(alias | grep 'NVIM_APPNAME' | sed -E 's/.*NVIM_APPNAME=([^ ]*).*/\1/')
}

function nvims() {
    local items=($(get_nvappnames))
    local config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config » " --height=50% --layout=reverse --border --exit-0)

    # Handle selection for Cancel or other configs
    if [[ $config == "Cancel" ]]; then
        echo "Operation cancelled"
        return 0
    fi

    NVIM_APPNAME=$config nvim "$@"
}

function nvim_clean() {
    local items=($(get_nvappnames))
    local name=$(printf "%s\n" "${items[@]}" | fzf --prompt="Select Neovim Config to Clean: " --height=50% --layout=reverse --border --exit-0)

    if [[ $name == "Cancel" ]]; then
        echo "Operation cancelled."
        return
    fi

    for dir in ~/.local/share/$name ~/.local/state/$name ~/.cache/$name; do
        if [[ -d $dir ]]; then
            rm -rf $dir
            echo "$dir deleted."
        else
            echo "$dir does not exist."
        fi
    done
}

function nvim_drop() {
    local items=($(get_nvappnames))
    local name=$(printf "%s\n" "${items[@]}" | fzf --prompt="Select Neovim Config to Drop: " --height=50% --layout=reverse --border --exit-0)

    if [[ $name == "Cancel" ]]; then
        echo "Operation cancelled."
        return
    fi

    local datetime=$(date "+%Y-%m-%d-%H-%M-%S")

    for dir in ~/.local/share/$name ~/.local/state/$name ~/.cache/$name; do
        if [[ -d $dir ]]; then
            rm -rf $dir
            echo "$dir deleted."
        else
            echo "$dir does not exist."
        fi
    done

    if [[ -d ~/.config/$name ]]; then
        mv ~/.config/$name ~/.config/${name}-${datetime}
        echo "~/.config/$name renamed to ~/.config/${name}-${datetime}."
    else
        echo "~/.config/$name does not exist."
    fi
}

bindkey -s ^v "nvims\n"
