#!/usr/bin/env zsh
zmodload zsh/zprof
## This shell is just a fast setup method for going on other shells
## I make no apology for its very tasteful design.
### Install nerd fonts
## bash -c  "$(curl -fsSL https://raw.githubusercontent.com/officialrajdeepsingh/nerd-fonts-installer/main/install.sh)"


#curl -L https://aka.ms/gcm/linux-install-source.sh | sh
 #   git-credential-manager configure




source_if_exists() {
    if [[ -f "$1" ]]; then
        source "$1"
        return 0
    else
        echo "File not found: $1" >&2
        return 1
    fi
}


create_bash_file() {
    local file_name="$1"

    if [[ -z "$file_name" ]]; then
        echo "Error: No filename specified" >&2
        return 1
    fi

    if [[ -e "$file_name" ]]; then
        echo "Error: File '$file_name' already exists" >&2
        return 1
    fi

    printf '#!/usr/bin/env bash\n' > "$file_name" || {
        echo "Error: Cannot write to '$file_name'" >&2
        return 1
    }

    chmod +x "$file_name"
}


str_replace() {
    local input="$1"
    local substring="$2"
    local replacement="${3:-}"

    echo "${input//$substring/$replacement}"
}


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
    if [ $# -gt 0 ]; then
        for arg in "$@"; do
            printf '%s\n' "$arg" | sed 's:/*$::'
        done
    else
        sed 's:/*$::'
    fi
}


clone_if_not_exist() {
  local filepath="$1" repo="$2"
  local DIRNAME="$(dirname "$filepath")"
  if [ ! -d "$DIRNAME" ]; then
    git clone --depth 1 "$repo" "$DIRNAME" || echo "Clone failed: $repo" >&2
  fi
}



export ENABLE_PATINA=1 # experimental faster syntax highlighter that increases shell startup by 50%
export ENABLE_STARSHIP=1
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH:$HOME/.cargo/bin:$HOME/.deno/bin
export ZSH="$HOME/.oh-my-zsh"
export  GCM_CREDENTIAL_STORE=secretservice
export MANPATH="/usr/local/man:$MANPATH"
export LANG=en_US.UTF-8
export LC_CTYPE="en_US.UTF-8"
export ARCHFLAGS="-arch $(uname -m)"
if ! [[ "$OSTYPE" == linux* ]]; then

export TERM=xterm
fi





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


ZSH_COMPLETIONS="${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions"
if [ ! -d  "$ZSH_COMPLETIONS" ] ; then
git clone --depth 1 https://github.com/zsh-users/zsh-completions.git "$ZSH_COMPLETIONS"
fi






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
    alias cargo-asm='\cargo-asm -q'
fi





local BINDKEYS="$HOME/.bindkeys"
if [ ! -f "$BINDKEYS" ]; then
curl -o "$BINDKEYS" https://raw.githubusercontent.com/alexcu2718/dotfiles/main/.bindkeys
fi

local SHELL_FUNCTIONS="$HOME/.shell_functions"
if [ ! -f "$SHELL_FUNCTIONS" ]; then
curl -o "$SHELL_FUNCTIONS" https://raw.githubusercontent.com/alexcu2718/dotfiles/main/.shell_functions
fi





mkdir -p ~/.cache/zsh

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh
zstyle ':completion:*' list-lines 12
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' matcher-list \
    '' \
    'm:{a-zA-Z}={A-Za-z}' \
    'r:|[._-]=* r:|=*'

zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}no matches for:%f %d'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' completer _complete _ignored


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
unset zle_bracketed_paste

autoload -U compinit && compinit


DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_LS_COLORS="false"
DISABLE_AUTO_TITLE="false"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

source "$ZSH/oh-my-zsh.sh"
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 14    # Check every 14 days





local AUTO_SUGGESTIONS="$ZSH/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
local FAST_SYNTAX="$ZSH/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
local AUTO_COMPLETE="$ZSH/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
local AUTO_ENV="$ZSH/plugins/autoenv/autoenv.plugin.zsh"
##i got fedup of recreating this everytime i wanted a shell to work on a new pc and too lazy for nix.



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



AUTOENV_ENABLE_LEAVE=yes
if command -v bat > /dev/null ; then
AUTOENV_VIEWER=cat
else
AUTOENV_VIEWER=bat
fi



source_if_exists "$HOME/.bindkeys"


if [[ "$ENABLE_PATINA" == "1" ]]  && command -v cargo > /dev/null ; then


    if ! command -v zsh-patina > /dev/null ; then

    if command -v paru > /dev/null ; then
    paru -Syu zsh-patina
    else
    cargo install --git https://github.com/michel-kraemer/zsh-patina
    fi
    fi




    local PATINA_CFG="$HOME/.config/zsh-patina"
    mkdir -p "$PATINA_CFG"

    if [[ ! -f "$PATINA_CFG/config.toml" ]] ; then
    curl -o "$PATINA_CFG/config.toml" https://raw.githubusercontent.com/alexcu2718/dotfiles/main/.config/zsh-patina/config.toml
    fi

    if [[ ! -f "$PATINA_CFG/custom-theme.toml" ]] ; then
    curl -o "$PATINA_CFG/custom-theme.toml" https://raw.githubusercontent.com/alexcu2718/dotfiles/main/.config/zsh-patina/custom-theme.toml
    fi





    eval "$(zsh-patina activate)"
    eval "$(zsh-patina completion)"

else
source  "$FAST_SYNTAX"
fi

source "$AUTO_COMPLETE"

fpath+=/usr/share/zsh/vendor-completions
fpath+=~/.zsh/completions
fpath+=~/.zfunc
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
source "$AUTO_SUGGESTIONS"


if command -v zoxide >/dev/null ; then
eval "$(zoxide init zsh)"
alias cd='z'
fi

if [[ "$OSTYPE" == linux* ]]; then
unalias open > /dev/null 2>&1
open() {

    if [[ -z "$1" ]]; then
        echo "Usage: open <path-or-command> [args...]" >&2
        return 1
    fi

    if [[ -d "$1" ]]; then
        if command -v thunar > /dev/null; then
            thunar "$1" "${@:2}" &> /dev/null &
            disown
            return 0
        fi

        if command -v dolphin > /dev/null; then
            dolphin "$1" "${@:2}" &> /dev/null &
            disown
            return 0
        fi

        if command -v xdg-open > /dev/null; then
            xdg-open "$1" &> /dev/null &
            disown
            return 0
        fi

        echo "Error: no file manager available for '$1'" >&2
        return 1
    fi

  ## this just allows you to open eg discord/firefox etc via terminal without cluttering it with lots of crap. fairly handy.
    if ! command -v "$1" &> /dev/null; then
        echo "Error: '$1' is not a valid command" >&2
        return 1
    fi

    command "$1" "${@:2}" &> /dev/null &
    disown
}
fi



alias ipython='\ipython --no-confirm-exit --no-banner --pprint'

### PYTHON BLOCK
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
## END PYTHON BLOCK







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









if command -v helix > /dev/null ; then
alias hx='helix'
fi




if [[ "$ENABLE_STARSHIP" == "1" ]] && command -v starship >/dev/null  ; then

local STARSHIP_LOCATION="$HOME/.config/starship.toml"

if [ ! -f "$STARSHIP_LOCATION" ]; then
mkdir -p "$HOME/.config"
curl -o "$STARSHIP_LOCATION" https://raw.githubusercontent.com/alexcu2718/dotfiles/main/.config/starship.toml
 fi

eval "$(starship init zsh)"
fi


if command -v eza > /dev/null; then
alias ls='eza --icons --color=always'
fi


source "$AUTO_ENV_HOME/activate.sh" # for shell use
source "$AUTO_ENV" ## FOR ZSH COMPLETIONS

alias VIEW_ASSEMBLY_OBJECT="objdump  -d --disassembler-options intel"
export PATH=$PATH:/home/alexc/.craft/
alias COMPILE_COMMANDS="cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON"
