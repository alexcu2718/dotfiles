export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH




export ZSH="$HOME/.oh-my-zsh"


if [ ! -d "$ZSH" ]; then
    git clone --depth 1 "https://github.com/ohmyzsh/ohmyzsh" "$ZSH"
fi



if ! command -v cargo >/dev/null && [[ "$OSTYPE" == darwin* ]]; then
    brew install rust
fi

if ! command -v starship >/dev/null;then
cargo install starship
fi

STARSHIP_LOCATION="$HOME/.config/starship.toml"
if [ ! -f "$STARSHIP_LOCATION" ]; then
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


refresh_zshrc() {
  local now=$(date +%s)
  local epoch_diff=$(( now - ZSHRC_LAST_REFRESH ))
  if (( epoch_diff >= 3 )); then
    ZSHRC_LAST_REFRESH=$now
    source ~/.zshrc &>/dev/null
    echo 'Refreshed .zshrc'
    eval "$(starship init $(mysh))"
  else
    echo 'Refresh ignored (cooldown active)'
  fi
  zle reset-prompt
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
  DIRNAME="$(dirname "$filepath")"
  if [ ! -d "$DIRNAME" ]; then
    git clone --depth 1 "$repo" "$DIRNAME" || echo "Clone failed: $repo" >&2
  fi
}

clone_if_not_exist "$AUTO_SUGGESTIONS" "https://github.com/zsh-users/zsh-autosuggestions.git"
clone_if_not_exist "$FAST_SYNTAX" "https://github.com/zdharma-continuum/fast-syntax-highlighting.git"
clone_if_not_exist "$AUTO_COMPLETE" "https://github.com/marlonrichert/zsh-autocomplete.git"
clone_if_not_exist "$AUTO_ENV" "https://github.com/hyperupcall/autoenv"



AUTO_ENV_DIR="$(dirname "$AUTO_ENV")"
AUTO_ENV_HOME="$HOME/.autoenv"
if [ ! -d  "$AUTO_ENV_HOME" ]; then
cp -r "$AUTO_ENV_DIR" "$AUTO_ENV_HOME"
fi


plugins=(gitfast  archlinux github   pip docker docker-compose
 gh fzf  systemd sudo eza  starship tldr  copyfile   zsh-interactive-cd
   uv  ufw vscode   rust python
 )


if [ ! -f "$HOME/.shell_functions" ] ; then
eval "$(starship init zsh)"
fi

source_if_exists "$AUTO_SUGGESTIONS"
source_if_exists  "$FAST_SYNTAX"
source_if_exists "$AUTO_COMPLETE"
source_if_exists "$AUTO_ENV"
source_if_exists "$HOME/.bindkeys"


if [ "$(whoami)" = "alexc" ] && [[ "$OSTYPE" == linux* ]]; then
source_if_exists ~/.shell_functions
fi

