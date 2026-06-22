#!/usr/bin/env zsh

#zmodload zsh/zprof
## This shell is just a fast setup method for going on other shells
## I make no apology for its very tasteful design.
### Install nerd fonts
## bash -c  "$(curl -fsSL https://raw.githubusercontent.com/officialrajdeepsingh/nerd-fonts-installer/main/install.sh)"
ulimit -n 8192

clone_if_not_exist() {
	local filepath="$1" repo="$2"
	local DIRNAME="$(dirname "$filepath")"
	if [ ! -d "$DIRNAME" ]; then
		git clone --depth 1 "$repo" "$DIRNAME" || echo "Clone failed: $repo" >&2
	fi
}

curl_if_missing() {
	local destination="$1" url="$2"
	if [[ ! -f "$destination" ]]; then
		curl --create-dirs -o "$destination" "$url"
	fi
}

lazy_load_completion_on_first_use() {
	local cmd="$1"
	local completion_cmd="$2"

	if ! command -v "$cmd" >/dev/null; then
		return
	fi

	eval "
function $cmd() {
	unfunction $cmd 2>/dev/null
	eval \"\$($completion_cmd 2>/dev/null)\"
	command $cmd \"\$@\"
}
"
}

export ENABLE_PATINA=1 # experimental faster syntax highlighter
export ENABLE_STARSHIP=1
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH:$HOME/.cargo/bin:$HOME/.deno/bin
export HEAPTRACK_ENABLE_DEBUGINFOD=1
export GCM_CREDENTIAL_STORE=secretservice
export MANPATH="/usr/local/man:$MANPATH"
export LANG=en_US.UTF-8
export LC_CTYPE="en_US.UTF-8"
export ARCHFLAGS="-arch $(uname -m)"

if [[ -n $SSH_CONNECTION ]]; then
	export EDITOR='vim'
else
	if command -v nvim >/dev/null; then
		export EDITOR='nvim'
	else
		export EDITOR='vim'
	fi
fi

local ZSH_PLUGIN_HOME="$HOME/.zsh/plugins"
ZSH_COMPLETIONS="$ZSH_PLUGIN_HOME/zsh-completions"
clone_if_not_exist "$ZSH_COMPLETIONS" https://github.com/zsh-users/zsh-completions.git

if command -v sccache >/dev/null; then
	export RUSTC_WRAPPER="$(which sccache)"
fi

if command -v bat >/dev/null; then
	alias cat="bat --paging=never --style=full"
	AUTOENV_VIEWER=bat
else
	AUTOENV_VIEWER=cat
fi

if [[ "$OSTYPE" == linux* ]] && command -v cargo >/dev/null; then
	if ! command -v cargo-asm >/dev/null; then

		cargo install cargo-show-asm ###the most recent version
	fi

	local CARGO_ASM_COMPLETIONS="$HOME/.zfunc/_cargoasm"
	if [ ! -f "$CARGO_ASM_COMPLETIONS" ]; then
		mkdir -p "$HOME/.zfunc"
		cargo-asm --bpaf-complete-style-zsh >"$CARGO_ASM_COMPLETIONS"
	fi

	alias cargo-asm='\cargo-asm -q'
fi

mkdir -p ~/.cache/zsh

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh
zstyle ':completion:*' list-lines 10
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':autocomplete:*' delay 0.15
zstyle ':autocomplete:*' ignored-input 'paru*'
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
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_LS_COLORS="false"
DISABLE_AUTO_TITLE="false"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
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

zstyle ':autocomplete:*' async on

local AUTO_SUGGESTIONS="$ZSH_PLUGIN_HOME/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
local FAST_SYNTAX="$ZSH_PLUGIN_HOME/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
local AUTO_COMPLETE="$ZSH_PLUGIN_HOME/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
local AUTO_ENV="$ZSH_PLUGIN_HOME/autoenv/autoenv.plugin.zsh"
##i got fedup of recreating this everytime i wanted a shell to work on a new pc and too lazy for nix.
clone_if_not_exist "$AUTO_SUGGESTIONS" "https://github.com/zsh-users/zsh-autosuggestions.git"
clone_if_not_exist "$FAST_SYNTAX" "https://github.com/zdharma-continuum/fast-syntax-highlighting.git"
clone_if_not_exist "$AUTO_COMPLETE" "https://github.com/marlonrichert/zsh-autocomplete.git"

local SHELL_FUNCTIONS="$HOME/.shell_functions"
curl_if_missing "$SHELL_FUNCTIONS" https://raw.githubusercontent.com/alexcu2718/dotfiles/main/.shell_functions

source ~/.shell_functions
#https://www.google.com/url?sa=t&source=web&rct=j&url=https%3A%2F%2Fwww.threads.com%2F%40beatrizmarianophotography%2Fpost%2FDE8IVn4iPW3&ved=0CBYQjRxqFwoTCLCb2q3ux5IDFQAAAAAdAAAAABA6&opi=89978449

local BINDKEYS="$HOME/.bindkeys"
curl_if_missing "$BINDKEYS" https://raw.githubusercontent.com/alexcu2718/dotfiles/main/.bindkeys

source "$HOME/.bindkeys"

local PYTHON_AND_GO=~/.python_and_go_stuff.zsh

curl_if_missing "$PYTHON_AND_GO" https://raw.githubusercontent.com/alexcu2718/dotfiles/refs/heads/main/.python_and_go_stuff

source "$PYTHON_AND_GO"

if [[ "$ENABLE_PATINA" == "1" ]] && command -v cargo >/dev/null; then
	if ! command -v zsh-patina >/dev/null; then
		if command -v paru >/dev/null; then
			paru -Syu zsh-patina
		else
			cargo install zsh-patina
		fi
	fi

	local PATINA_CFG="$HOME/.config/zsh-patina"

	curl_if_missing "$PATINA_CFG/config.toml" \
		https://raw.githubusercontent.com/alexcu2718/dotfiles/main/.config/zsh-patina/config.toml

	curl_if_missing "$PATINA_CFG/custom-theme.toml" \
		https://raw.githubusercontent.com/alexcu2718/dotfiles/main/.config/zsh-patina/custom-theme.toml

	eval "$(zsh-patina activate)"
	lazy_load_completion_on_first_use "zsh-patina" "zsh-patina completion"
else
	source "$FAST_SYNTAX" ## BE VERY CAREFUL WITH THE ORDERING OF THIS AND THE FOLLOWING
### THERE IS SOME VERY ESOTERIC BEHAVIOUR CAUSING ERRORS IN SHELL PROMPTS, IE cutting off the last 3 lines of the terminal so cutting off the visual display from Y/n commands

#(read: Alex cannot be bothered to read into esoteric zsh tutorials written on raw html and a dream of 3d graphics)
fi
source "$AUTO_SUGGESTIONS"
source "$AUTO_COMPLETE"

fpath+=/usr/share/zsh/vendor-completions
fpath+=~/.zsh/completions
fpath+=~/.zfunc
fpath+="$ZSH_COMPLETIONS/src"

if command -v zoxide >/dev/null; then
	eval "$(zoxide init zsh)"
	alias cd='z'
fi

source ~/.python_and_go_stuff.zsh

if [[ "$ENABLE_STARSHIP" == "1" ]] && command -v starship >/dev/null; then

	local STARSHIP_LOCATION="$HOME/.config/starship.toml"

	curl_if_missing "$STARSHIP_LOCATION" https://raw.githubusercontent.com/alexcu2718/dotfiles/main/.config/starship.toml

	eval "$(starship init zsh)"
fi

if command -v eza >/dev/null; then
	alias ls='eza --icons --color=always'
fi

# lazy load auto env
_autoenv_loaded=0
_autoenv_lazy_chpwd() {
	if ((!_autoenv_loaded)) && [[ -f ".env" ]]; then
		_autoenv_loaded=1
		local _ae_dir="$HOME/.zsh/plugins/autoenv"
		local _ae_plugin="$_ae_dir/autoenv.plugin.zsh"
		clone_if_not_exist "$_ae_plugin" "https://github.com/hyperupcall/autoenv"
		[[ ! -d "$HOME/.autoenv" ]] && cp -r "$_ae_dir" "$HOME/.autoenv"
		AUTOENV_ENABLE_LEAVE=yes
		source "$_ae_plugin"
	fi
}
autoload -Uz add-zsh-hook
add-zsh-hook chpwd _autoenv_lazy_chpwd
_autoenv_lazy_chpwd

alias VIEW_ASSEMBLY_OBJECT="objdump  -d --disassembler-options intel"
alias COMPILE_COMMANDS="cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON"

alias gcl='git clone'

lazy_load_completion_on_first_use "mise" "mise activate zsh"

lazy_load_completion_on_first_use "juliaup" "juliaup completions zsh"

lazy_load_completion_on_first_use "fdf" "fdf --generate zsh"

#zprof
