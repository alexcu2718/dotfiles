#!/usr/bin/env zsh

## This shell is just a fast setup method for going on other shells
## I make no apology for its very tasteful design.
### Install nerd fonts
## bash -c  "$(curl -fsSL https://raw.githubusercontent.com/officialrajdeepsingh/nerd-fonts-installer/main/install.sh)"

export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH:$HOME/.cargo/bin
export ZSH="$HOME/.oh-my-zsh"
export  GCM_CREDENTIAL_STORE=secretservice
export MANPATH="/usr/local/man:$MANPATH"
export LANG=en_US.UTF-8
export LC_CTYPE="en_US.UTF-8"
export ARCHFLAGS="-arch $(uname -m)"
 export TERM=xterm



if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  if command -v nvim >/dev/null 2>&1; then
    export EDITOR='nvim'
  else
    export EDITOR='vim'
  fi
fi

if [ ! -d "$ZSH" ]; then
    git clone --depth 1 "https://github.com/ohmyzsh/ohmyzsh" "$ZSH"
fi



if ! command -v git-credential-manager >/dev/null 2>&1 && [[ "$OSTYPE" == linux* ]]; then
    curl -L https://aka.ms/gcm/linux-install-source.sh | sh
    git-credential-manager configure
fi

##this is for a friends config, i dont use macos except on vms(this is handy tho.)
# if [[ "$OSTYPE" == darwin* ]]; then
#     local P10K="/usr/local/opt/powerlevel10k/share/powerlevel10k/powerlevel10k.zsh-theme"
#     if [ ! -f "$P10K" ]; then
#         brew install powerlevel10k
#     fi
#     source "$P10K"
# fi
### Actually this is a terrible plugin, its so slow...


if command -v sccache >/dev/null 2>&1; then
export RUSTC_WRAPPER="$(which sccache)"
fi





if command -v bat >/dev/null 2>&1; then
alias cat="bat --paging=never"
fi



if  [[ "$OSTYPE" == linux* ]]  && command -v cargo >/dev/null 2>&1; then
    if ! command -v cargo-asm >/dev/null 2>&1; then

        cargo install cargo-show-asm ###the most recent version
    fi



    if command -v cargo-asm >/dev/null 2>&1; then
        local CARGO_ASM_COMPLETIONS="$HOME/.zfunc/_cargoasm"
        if [ ! -f "$CARGO_ASM_COMPLETIONS" ]; then
            mkdir -p "$HOME/.zfunc"
            cargo-asm --bpaf-complete-style-zsh > "$CARGO_ASM_COMPLETIONS"
        fi
    fi
fi




local STARSHIP_LOCATION="$HOME/.config/starship.toml"

if [ ! -f "$STARSHIP_LOCATION" ]; then
mkdir -p "$HOME/.config"
curl -o "$STARSHIP_LOCATION" https://raw.githubusercontent.com/alexcu2718/dotfiles/main/.config/starship.toml
fi

local BINDKEYS="$HOME/.bindkeys"
if [ ! -f "$BINDKEYS" ]; then
curl -o "$BINDKEYS" https://raw.githubusercontent.com/alexcu2718/dotfiles/main/.bindkeys
fi

local SHELL_FUNCTIONS="$HOME/.shell_functions"
if [ ! -f "$SHELL_FUNCTIONS" ]; then
curl -o "$SHELL_FUNCTIONS" https://raw.githubusercontent.com/alexcu2718/dotfiles/main/.shell_functions
fi





autoload -U compinit
compinit


zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh
zstyle ':completion:*' list-lines 15
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
fpath+=/usr/share/zsh/vendor-completions
fpath+=~/.zsh/completions
fpath+=~/.zfunc

unset zle_bracketed_paste


setopt appendhistory
setopt sharehistory
setopt incappendhistory
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY

source_if_exists() {
    if [[ -f "$1" ]]; then
        source "$1"
        return 0
    else
        echo "File not found: $1" >&2
        return 1
    fi
}



source_if_exists "$ZSH/oh-my-zsh.sh"
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 14    # Check every 14 days
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_LS_COLORS="false"
DISABLE_AUTO_TITLE="false"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"




local AUTO_SUGGESTIONS="$ZSH/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
local FAST_SYNTAX="$ZSH/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
local AUTO_COMPLETE="$ZSH/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
local AUTO_ENV="$ZSH/plugins/autoenv/autoenv.plugin.zsh"
##i got fedup of recreating this everytime i wanted a shell to work on a new pc and too lazy for nix.

clone_if_not_exist() {
  local filepath="$1" repo="$2"
  local DIRNAME="$(dirname "$filepath")"
  if [ ! -d "$DIRNAME" ]; then
    git clone --depth 1 "$repo" "$DIRNAME" || echo "Clone failed: $repo" >&2
  fi
}

clone_if_not_exist "$AUTO_SUGGESTIONS" "https://github.com/zsh-users/zsh-autosuggestions.git"
clone_if_not_exist "$FAST_SYNTAX" "https://github.com/zdharma-continuum/fast-syntax-highlighting.git"
clone_if_not_exist "$AUTO_COMPLETE" "https://github.com/marlonrichert/zsh-autocomplete.git"
clone_if_not_exist "$AUTO_ENV" "https://github.com/hyperupcall/autoenv"



local AUTO_ENV_HOME="$HOME/.autoenv"
if [ ! -d  "$AUTO_ENV_HOME" ]; then
git clone --depth 1 "https://github.com/hyperupcall/autoenv" "$AUTO_ENV_HOME"
fi





if [ "$(whoami)" = "alexc" ] && [[ "$OSTYPE" == linux* ]]; then

source_if_exists ~/.shell_functions
#https://www.google.com/url?sa=t&source=web&rct=j&url=https%3A%2F%2Fwww.threads.com%2F%40beatrizmarianophotography%2Fpost%2FDE8IVn4iPW3&ved=0CBYQjRxqFwoTCLCb2q3ux5IDFQAAAAAdAAAAABA6&opi=89978449
alias xdg-open="xdg-open 2&>/dev/null"
fi


if [  -f "$HOME/.shell_functions" ] && command -v starship >/dev/null &&  [[ "$OSTYPE" == linux* ]] ; then
eval "$(starship init zsh)"
fi

AUTOENV_ENABLE_LEAVE=yes
AUTOENV_VIEWER=cat

source_if_exists "$AUTO_ENV_HOME/activate.sh"
source_if_exists "$AUTO_SUGGESTIONS"
source_if_exists  "$FAST_SYNTAX"
source_if_exists "$AUTO_COMPLETE"
source_if_exists "$AUTO_ENV"
source_if_exists "$HOME/.bindkeys"



if [[ "$OSTYPE" == linux* ]] then ;
unalias open > /dev/null 2>&1
open() {
  ## this just allows you to open eg discord/firefox etc via terminal without cluttering it with lots of crap. fairly handy.
    if ! command -v "$1" &> /dev/null; then
        echo "Error: '$1' is not a valid command" >&2
        return 1
    fi
    command "$1" "${@:2}" &> /dev/null &
    disown
}
fi



if command -v uv  >/dev/null 2>&1; then

if ! command -v pipx >/dev/null 2>&1; then
uv tool install pipx
fi


if ! command -v register-python-argcomplete  >/dev/null 2>&1 ; then
pipx install argcomplete
fi


if ! command -v tldr >/dev/null 2>&1 ; then
pipx install tldr
fi


eval "$(tldr --print-completion zsh)"

eval "$(register-python-argcomplete pipx)"

for pkg in pre-commit ruff ty ; do
        if ! command -v "$pkg" >/dev/null 2>&1; then
            uv tool install "$pkg"
        fi


local RUFF_COMPLETIONS="$HOME/.zfunc/_ruff"
if [ ! -f "$RUFF_COMPLETIONS" ]; then
    mkdir -p "$HOME/.zfunc"
    ruff generate-shell-completion zsh > "$RUFF_COMPLETIONS"
fi

done


eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"
fi







if command -v fzf  &> /dev/null; then

source <(fzf --zsh)

fi


if command -v go-gitmoji-cli &> /dev/null; then
eval "$(go-gitmoji-cli completion zsh)"
alias gitmoji="go-gitmoji-cli"
fi



plugins=(gitfast   github   pip docker docker-compose
 gh  systemd sudo       zsh-interactive-cd
   uv  ufw vscode   rust python
 )


if command -v starship &> /dev/null ; then
plugins+=starship
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
