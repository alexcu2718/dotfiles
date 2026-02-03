#!/usr/bin/env zsh

## This shell is just a fast setup method for going on other shells
## I make no apology for its very tasteful design.

export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH:$HOME/.cargo/bin
export ZSH="$HOME/.oh-my-zsh"
export  GCM_CREDENTIAL_STORE=secretservice
export GIT_ASKPASS=/opt/visual-studio-code/resources/app/extensions/git/dist/askpass.sh
export MANPATH="/usr/local/man:$MANPATH"
export LANG=en_US.UTF-8
export LC_CTYPE="en_US.UTF-8"
export ARCHFLAGS="-arch $(uname -m)"

if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
 else
   export EDITOR='nvim'
 fi


if [ ! -d "$ZSH" ]; then
    git clone --depth 1 "https://github.com/ohmyzsh/ohmyzsh" "$ZSH"
fi


##this is for a friends config, i dont use macos except on vms(this is handy tho.)
if [[ "$OSTYPE" == darwin* ]]; then
    local P10K="/usr/local/opt/powerlevel10k/share/powerlevel10k/powerlevel10k.zsh-theme"
    if [ ! -f "$P10K" ]; then
        brew install powerlevel10k
    fi
    source "$P10K"
fi


if command -v uv >/dev/null 2>&1; then
    for pkg in pre-commit ruff ty; do
        if ! command -v "$pkg" >/dev/null 2>&1; then
            uv tool install "$pkg"
        fi
    done
fi


if command -v sccache >/dev/null 2>&1; then
export RUSTC_WRAPPER="$(which sccache)"
fi

if command -v ruff &> /dev/null; then
    local RUFF_COMPLETIONS="$HOME/.zfunc/_ruff"
    if [ ! -f "$RUFF_COMPLETIONS" ]; then
        mkdir -p "$HOME/.zfunc"
        ruff generate-shell-completion zsh > "$RUFF_COMPLETIONS"
    fi
fi






if command -v cargo >/dev/null 2>&1; then
    if ! command -v cargo-asm >/dev/null 2>&1; then
        echo "Installing cargo-asm via cargo..." >&2
        cargo install cargo-asm
    fi

    if command -v cargo-asm >/dev/null 2>&1; then
        local CARGO_ASM_COMPLETIONS="$HOME/.zfunc/_cargoasm"
        if [ ! -f "$CARGO_ASM_COMPLETIONS" ]; then
            mkdir -p "$HOME/.zfunc"
            cargo-asm --bpaf-complete-style-zsh > "$CARGO_ASM_COMPLETIONS"
        fi
    fi
fi




STARSHIP_LOCATION="$HOME/.config/starship.toml"

if [ ! -f "$STARSHIP_LOCATION" ]; then
mkdir -p "$HOME/.config"
curl -o "$STARSHIP_LOCATION" https://raw.githubusercontent.com/alexcu2718/dotfiles/main/.config/starship.toml
fi

BINDKEYS="$HOME/.bindkeys"
if [ ! -f "$BINDKEYS" ]; then
curl -o "$BINDKEYS" https://raw.githubusercontent.com/alexcu2718/dotfiles/main/.bindkeys
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


AUTO_SUGGESTIONS="$ZSH/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
FAST_SYNTAX="$ZSH/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
AUTO_COMPLETE="$ZSH/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
AUTO_ENV="$ZSH/plugins/autoenv/autoenv.plugin.zsh"
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



AUTO_ENV_HOME="$HOME/.autoenv"
if [ ! -d  "$AUTO_ENV_HOME" ]; then
git clone --depth 1 "https://github.com/hyperupcall/autoenv" "$AUTO_ENV_HOME"
fi





if [ "$(whoami)" = "alexc" ] && [[ "$OSTYPE" == linux* ]]; then

source_if_exists ~/.shell_functions
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




plugins=(gitfast  archlinux github   pip docker docker-compose
 gh fzf  systemd sudo eza  starship tldr  copyfile   zsh-interactive-cd
   uv  ufw vscode   rust python
 )

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



if command -v uv  >/dev/null 2>&1; then
eval "$(uv generate-shell-completion "$(mysh)")"
eval "$(uvx --generate-shell-completion "$(mysh)")"
fi


backup() {


    local file="$1"


    if [[ ! -e "$file" ]]; then
        echo "Error: File '$file' does not exist"
        return 1
    fi

    # If no .bak exists, create it
    if [[ ! -e "${file}.bak" ]]; then
        cp "$file" "${file}.bak"
        echo "Created backup: ${file}.bak"
        return 0
    fi


    local counter=2
    while [[ -e "${file}.bak${counter}" ]]; do
        ((counter++))
    done

    cp "$file" "${file}.bak${counter}"
    echo "Created backup: ${file}.bak${counter}"
}