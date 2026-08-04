#!/usr/bin/env bash


# If not running interactively, don't do anything
[[ $- != *i* ]] && return



alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '





if  command -v starship >/dev/null &&  [[ "$OSTYPE" == linux* ]] ; then
eval "$(starship init bash)"
fi

backup() {
    local target="$1"

    if [[ ! -e "$target" ]]; then
        echo "Error: '$target' does not exist"
        return 1
    fi


    if [[ -d "$target" ]]; then
        if [[ ! -e "${target}.bak" ]]; then
            cp -r "$target" "${target}.bak"
            echo "Created directory backup: ${target}.bak"
            return 0
        fi

        local counter=2
        while [[ -d "${target}.bak${counter}" ]]; do
            ((counter++))
        done

        cp -r "$target" "${target}.bak${counter}"
        echo "Created directory backup: ${target}.bak${counter}"
    else
        if [[ ! -e "${target}.bak" ]]; then
            cp "$target" "${target}.bak"
            echo "Created backup: ${target}.bak"
            return 0
        fi

        local counter=2
        while [[ -e "${target}.bak${counter}" ]]; do
            ((counter++))
        done

        cp "$target" "${target}.bak${counter}"
        echo "Created backup: ${target}.bak${counter}"
    fi
}

strip_slashes() {
    sed 's:/*$::'
}
alias hx='helix'



# Flyline - enhanced Bash experience
enable -f /home/alexc/.local/lib/libflyline.so flyline
