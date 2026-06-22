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

if ! [[ "$OSTYPE" == linux* ]]; then

	export TERM=xterm
fi

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
clone_if_not_exist "$ZSH_COMPLETIONS" https://github.com/zsh-users/zsh-completions.git "$ZSH_COMPLETIONS"

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

#https://scottspence.com/posts/speeding-up-my-zsh-shell
## you dont need this with the plugins
# autoload -Uz compinit
# if [ "$(date +'%j')" != "$(stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)" ]; then
#     compinit
# else
#     compinit -C
# fi

# {
#   if [[ -s "$HOME/.zcompdump" && (! -s "$HOME/.zcompdump.zwc" || "$HOME/.zcompdump" -nt "$HOME/.zcompdump.zwc") ]]; then
#     zcompile "$HOME/.zcompdump"
#   fi
# } &!

zstyle ':autocomplete:*' async on

local AUTO_SUGGESTIONS="$ZSH_PLUGIN_HOME/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
local FAST_SYNTAX="$ZSH_PLUGIN_HOME/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
local AUTO_COMPLETE="$ZSH_PLUGIN_HOME/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
local AUTO_ENV="$ZSH_PLUGIN_HOME/autoenv/autoenv.plugin.zsh"
##i got fedup of recreating this everytime i wanted a shell to work on a new pc and too lazy for nix.
clone_if_not_exist "$AUTO_SUGGESTIONS" "https://github.com/zsh-users/zsh-autosuggestions.git"
clone_if_not_exist "$FAST_SYNTAX" "https://github.com/zdharma-continuum/fast-syntax-highlighting.git"
clone_if_not_exist "$AUTO_COMPLETE" "https://github.com/marlonrichert/zsh-autocomplete.git"

if [ "$(whoami)" = "alexc" ] && [[ "$OSTYPE" == linux* ]]; then

	local SHELL_FUNCTIONS="$HOME/.shell_functions"
	if [ ! -f "$SHELL_FUNCTIONS" ]; then
		curl -o "$SHELL_FUNCTIONS" https://raw.githubusercontent.com/alexcu2718/dotfiles/main/.shell_functions
	fi

	source ~/.shell_functions
	#https://www.google.com/url?sa=t&source=web&rct=j&url=https%3A%2F%2Fwww.threads.com%2F%40beatrizmarianophotography%2Fpost%2FDE8IVn4iPW3&ved=0CBYQjRxqFwoTCLCb2q3ux5IDFQAAAAAdAAAAABA6&opi=89978449

fi

local BINDKEYS="$HOME/.bindkeys"
if [ ! -f "$BINDKEYS" ]; then
	curl -o "$BINDKEYS" https://raw.githubusercontent.com/alexcu2718/dotfiles/main/.bindkeys
fi

source "$HOME/.bindkeys"

if [[ "$ENABLE_PATINA" == "1" ]] && command -v cargo >/dev/null; then
	if ! command -v zsh-patina >/dev/null; then
		if command -v paru >/dev/null; then
			paru -Syu zsh-patina
		else
			cargo install --git https://github.com/michel-kraemer/zsh-patina
		fi
	fi

	local PATINA_CFG="$HOME/.config/zsh-patina"
	mkdir -p "$PATINA_CFG"

	if [[ ! -f "$PATINA_CFG/config.toml" ]]; then
		curl -o "$PATINA_CFG/config.toml" \
			https://raw.githubusercontent.com/alexcu2718/dotfiles/main/.config/zsh-patina/config.toml
	fi

	if [[ ! -f "$PATINA_CFG/custom-theme.toml" ]]; then
		curl -o "$PATINA_CFG/custom-theme.toml" \
			https://raw.githubusercontent.com/alexcu2718/dotfiles/main/.config/zsh-patina/custom-theme.toml
	fi

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

alias ipython='\ipython --no-confirm-exit --no-banner --pprint'

### PYTHON BLOCK
if command -v uv >/dev/null; then

	if ! command -v pipx >/dev/null; then
		uv tool install pipx
	fi

	if ! command -v register-python-argcomplete >/dev/null; then
		pipx install argcomplete
	fi

	if ! command -v tldr >/dev/null; then
		pipx install tldr
	fi

	for pkg in pre-commit ruff ty; do
		if ! command -v "$pkg" >/dev/null; then
			uv tool install "$pkg"
		fi

		local RUFF_COMPLETIONS="$HOME/.zfunc/_ruff"
		if [ ! -f "$RUFF_COMPLETIONS" ]; then
			mkdir -p "$HOME/.zfunc"
			ruff generate-shell-completion zsh >"$RUFF_COMPLETIONS"
		fi

	done
	lazy_load_completion_on_first_use "pipx" "register-python-argcomplete pipx"
	lazy_load_completion_on_first_use "tldr" "tldr --print-completion zsh"
	lazy_load_completion_on_first_use "uv" "uv generate-shell-completion zsh"
	lazy_load_completion_on_first_use "uvx" "uvx --generate-shell-completion zsh"
fi
## END PYTHON BLOCK

### GO SECTION
if command -v go >/dev/null; then
	local GOBIN="$(go env GOBIN)"
	if [[ -z "$GOBIN" ]]; then
		local GOPATH="$(go env GOPATH)"
		export PATH="$PATH:$GOPATH/bin"
	else
		export PATH="$PATH:$GOBIN"
	fi

	if ! command -v shfmt >/dev/null; then
		go install mvdan.cc/sh/v3/cmd/shfmt@latest
	fi

fi

### END GO SECTION

if command -v fzf >/dev/null; then

	source <(fzf --zsh)

fi

if command -v go-gitmoji-cli >/dev/null; then
	lazy_load_completion_on_first_use "go-gitmoji-cli" "go-gitmoji-cli completion zsh"
	alias gitmoji="go-gitmoji-cli"
fi

if command -v helix >/dev/null; then
	alias hx='helix'
fi

if [[ "$ENABLE_STARSHIP" == "1" ]] && command -v starship >/dev/null; then

	local STARSHIP_LOCATION="$HOME/.config/starship.toml"

	if [ ! -f "$STARSHIP_LOCATION" ]; then
		mkdir -p "$HOME/.config"
		curl -o "$STARSHIP_LOCATION" https://raw.githubusercontent.com/alexcu2718/dotfiles/main/.config/starship.toml
	fi

	eval "$(starship init zsh)"
fi

if command -v eza >/dev/null; then
	alias ls='eza --icons --color=always'
fi

#### THESE UNBELIEVABLY F******* SLOW DO NOT USE THEM HOLY SHIT.
# clone_if_not_exist "$AUTO_ENV" "https://github.com/hyperupcall/autoenv"

# if [ ! -d "$HOME/.autoenv" ] ; then
#  cp -r "$(dirname "$AUTO_ENV")" "$HOME/.autoenv"
# fi

#AUTOENV_ENABLE_LEAVE=yes
#source "$HOME/.autoenv/activate.sh" # for shell use
# source "$AUTO_ENV"                  ## FOR ZSH COMPLETIONS

alias VIEW_ASSEMBLY_OBJECT="objdump  -d --disassembler-options intel"
alias COMPILE_COMMANDS="cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON"

alias gcl='git clone'

lazy_load_completion_on_first_use "mise" "mise activate zsh"

lazy_load_completion_on_first_use "juliaup" "juliaup completions zsh"

lazy_load_completion_on_first_use "fdf" "fdf --generate zsh"

#zprof
