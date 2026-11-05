#!/usr/bin/env zsh

#zmodload zsh/zprof
## This shell is just a fast setup method for going on other shells
## I make no apology for its very tasteful design.
### Install nerd fonts
## bash -c  "$(curl -fsSL https://raw.githubusercontent.com/officialrajdeepsingh/nerd-fonts-installer/main/install.sh)"

## termux font patch
# mkdir -p ~/.termux &&  curl -fLo ~/.termux/font.ttf \
# 'https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/NerdFonts/MesloLGS%20NF%20Regular.ttf' && \
# termux-reload-settings

[[ $USER == alexc ]]
declare -gi ENABLE_PATINA=$((!$?)) ENABLE_STARSHIP=$((!$?))
## for debugging
alias zprofile='ZSH_DEBUG=1 zsh -i -c exit'
alias zbenchmark='hyperfine --warmup 3 -N "zsh -i -c exit"'
declare -gi _ZSH_DEBUG=${ZSH_DEBUG:-0}

if ((_ZSH_DEBUG)); then
	zmodload zsh/zprof
fi

[[ $TERM == (vt220|vt100|dumb) ]] && export TERM=xterm-256color

function clone_if_not_exist() {
	local dir="${1:h}" repo="$2"
	[[ -d "$dir" ]] && return 0
	git clone --depth 1 "$repo" "$dir" || echo "Clone failed: $repo" >&2
}

function curl_if_missing() {
	local destination="$1" url="$2"
	if [[ ! -f "$destination" ]]; then
		curl -fsSL --create-dirs -o "$destination" "$url" ||
			{
				echo "Download failed: $url" >&2
				rm -f "$destination"
				return 1
			}
	fi
}

function lazy_load_completion_on_first_use() {
	local cmd="$1"
	local completion_cmd="$2"

	if ! command -v "$cmd" >/dev/null; then
		return 0
	fi

	eval "
function $cmd() {
	unfunction $cmd 2>/dev/null
	eval \"\$($completion_cmd 2>/dev/null)\"
	command $cmd \"\$@\"
}
"
}

export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH:$HOME/.cargo/bin:$HOME/.deno/bin
export HEAPTRACK_ENABLE_DEBUGINFOD=1
export GCM_CREDENTIAL_STORE=secretservice
export MANPATH="/usr/local/man:$MANPATH"
export LANG="${LANG:-en_US.UTF-8}"
export LC_CTYPE="${LC_CTYPE:-en_US.UTF-8}"
export ARCHFLAGS="-arch $CPUTYPE"

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
local ZSH_COMPLETIONS="$ZSH_PLUGIN_HOME/zsh-completions"

clone_if_not_exist "$ZSH_COMPLETIONS/zsh-completions.plugin.zsh" \
	https://github.com/zsh-users/zsh-completions.git

command -v sccache >/dev/null && export RUSTC_WRAPPER="$(command -v sccache)"
command -v bat >/dev/null && alias cat="bat --paging=never --style=full"
## can delete
if [[ "$USER" == "alexc" && "$OSTYPE" == linux* ]] && command -v cargo >/dev/null; then
	if ! command -v cargo-asm >/dev/null; then
		# Installs the latest published version (cargo-show-asm provides the cargo-asm binary)
		cargo install cargo-show-asm --locked
	fi

	CARGO_ASM_COMPLETIONS="$HOME/.zfunc/_cargoasm"
	if [[ ! -f "$CARGO_ASM_COMPLETIONS" ]]; then
		mkdir -p "$HOME/.zfunc"
		cargo-asm --bpaf-complete-style-zsh >"$CARGO_ASM_COMPLETIONS"
	fi

	alias cargo-asm='\cargo-asm -q'
fi

[[ -d "$HOME/.cache/zsh" ]] || mkdir -p "$HOME/.cache/zsh"

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh
zstyle ':completion:*' list-lines 5
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':autocomplete:*' delay 0.15
zstyle ':autocomplete:*' ignored-input 'paru*' ## cant get this to work for some....reason.
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' matcher-list \
	'' \
	'm:{a-zA-Z}={A-Za-z}' \
	'r:|[._-]=* r:|=*'

zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}no matches for:%f %d'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' completer _complete _ignored
zstyle ':completion::complete:*' gain-privileges 1
setopt appendhistory
setopt interactive_comments
setopt sharehistory
setopt incappendhistory
bindkey -e #evil mode
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
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
#local AUTO_ENV="$ZSH_PLUGIN_HOME/autoenv/autoenv.plugin.zsh"
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

curl_if_missing "$PYTHON_AND_GO" https://raw.githubusercontent.com/alexcu2718/dotfiles/refs/heads/main/.python_and_go_stuff.zsh

source "$PYTHON_AND_GO"

if (($ENABLE_PATINA)) && command -v cargo >/dev/null; then
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

# if [[ "$ENABLE_DEJA"  == "1" ]]  && command -v deja > /dev/null ; then
# local DEJA_PLUGIN="${ZSH_PLUGIN_HOME}/plugins/deja/deja.plugin.zsh"
# curl_if_missing "$DEJA_PLUGIN" https://raw.githubusercontent.com/Giammarco-Ferranti/deja/main/deja.plugin.zsh
# source "$DEJA_PLUGIN"
# else
#source "$AUTO_SUGGESTIONS"
# fi

typeset -U fpath
for d in /usr/share/zsh/vendor-completions; do
	[[ -d $d ]] && fpath=($fpath "$d")
done
for d in "$ZSH_COMPLETIONS/src" ~/.zfunc ~/.zsh/completions; do
	[[ -d $d ]] && fpath=("$d" $fpath)
done
source "$AUTO_SUGGESTIONS"
source "$AUTO_COMPLETE"
# zsh-autocomplete's own lazy zasync autoload silently fails, so load it explicitly
[[ -f ~/.cache/zsh/zasync/zasync ]] && autoload -Uz +X ~/.cache/zsh/zasync/zasync

if command -v zoxide >/dev/null; then
	__zoxide_lazy_init() {
		unfunction cd cdi 2>/dev/null
		unfunction __zoxide_lazy_init
		eval "$(zoxide init --cmd cd zsh)"
	}
	cd() {
		__zoxide_lazy_init
		cd "$@"
	}
	cdi() {
		__zoxide_lazy_init
		cdi "$@"
	}
fi
#starship 1.27.0
#^ this is the version of starship i use, when i try it on older distros(or...god forbid windows) or windows it gives fucking annoying errors
## not debugging that yet, too lazy.
setup_starship() {
	(($ENABLE_STARSHIP)) || return 0

	if ! command -v starship >/dev/null 2>&1; then
		case "$(uname -s)" in
		Darwin)
			brew install starship
			;;
		Linux)
			echo "starship not found. This will run the remote install script (may use sudo)."
			echo "To disable, set ENABLE_STARSHIP=0 in your .zshrc."
			if read -q "REPLY?Install now? [y/N] "; then
				echo
				curl -sS https://starship.rs/install.sh | sh -s -- -y
			else
				return 0
			fi
			;;
		esac
	fi

	local config_path="$HOME/.config/starship.toml"
	curl_if_missing "$config_path" \
		https://raw.githubusercontent.com/alexcu2718/dotfiles/main/.config/starship.toml
	eval "$(starship init zsh)"
}

setup_starship
unfunction setup_starship
command -v eza >/dev/null && alias ls='eza --icons --color=always'

alias CPUINFO='cpupower  frequency-info'

# commented out because interferes with zoxide
# i cant quite figure out an elegant fix. eh.

# _autoenv_loaded=0
# _autoenv_lazy_chpwd() {
# 	if ((!_autoenv_loaded)) && [[ -f ".env" ]]; then
# 		_autoenv_loaded=1
# 		local _ae_dir="$HOME/.zsh/plugins/autoenv"
# 		local _ae_plugin="$_ae_dir/autoenv.plugin.zsh"
# 		clone_if_not_exist "$_ae_plugin" "https://github.com/hyperupcall/autoenv"
# 		[[ ! -d "$HOME/.autoenv" ]] && cp -r "$_ae_dir" "$HOME/.autoenv"
# 		AUTOENV_ENABLE_LEAVE=yes
# 		source "$_ae_plugin"
# 	fi
# }
# autoload -Uz add-zsh-hook
# add-zsh-hook chpwd _autoenv_lazy_chpwd
# _autoenv_lazy_chpwd

alias VIEW_ASSEMBLY_OBJECT="objdump  -d --disassembler-options intel"
alias COMPILE_COMMANDS="cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON"

alias gcl='git clone'

lazy_load_completion_on_first_use "mise" "mise activate zsh"

lazy_load_completion_on_first_use "juliaup" "juliaup completions zsh"

lazy_load_completion_on_first_use "fdf" "fdf --generate zsh"

export DEBUGINFOD_URLS="https://debuginfod.archlinux.org"

alias SSHTOASTER='ssh -p 22 alexc@192.168.0.115' # my potato media laptop, should make it an alias but its barely alive and may explode on me anytime soon, free heating in winter i guess.

export TMOUT=0 # can cause issues on bash..

PHONE_ADDR='u0_a370@192.168.1.117'
alias SSHPHONE="ssh -p 8022 $PHONE_ADDR" # too lazy to setup aliases since switcing phone soony

PI_ADDR='192.168.1.107'
PI_USER='alexc'

alias RASPBERRY_PI_SSH="ssh -p 22 $PI_USER@$PI_ADDR"

picopy() {
	if [[ $# -eq 0 ]]; then
		echo "usage: picopy file [file...]"
		return 1
	fi
	scp "$@" "$PI_USER@$PI_ADDR:movies_tv/"
}
##  ssh-copy-id -p 8022 $PHONE_ADDR

if [[ "$OSTYPE" == darwin* ]] && command -v brew >/dev/null; then

	if ! command -v grm >/dev/null; then ### check for gnu coreutils  via grm instead of invoking brew, this isn't perfect
		brew install coreutils              ## we can't check paths because homebrew installs in different places for everyone, yay.
		### TODO! ADD A HOMEBREW INSTALL TO THE TOP OF THIS SCRIPT FOR MAC
	fi ### I don't like BSD coreutils because of the argument parsing...
	export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
	## core utils should instore modern bash and preprend it to path, not checked tho lol.
	if ! bash -c '(( BASH_VERSINFO[0] >=5  ))'; then ### get the modern bash instead of one from 2007....
		brew install bash
	fi
	## not sufficiently tested, *may* cause infinite loops on a messed up PATH, oh well, worked for me.

fi

local UV_ENV="$ZSH_PLUGIN_HOME/zsh-uv-env/zsh-uv-env.plugin.zsh"
local _uv_env_loaded=0

function _uv_env_lazy_load() {
	# check if already loaded
	[[ $_uv_env_loaded -eq 1 ]] && return 0

	# load if .venv exists in current directory
	if [[ -d "$PWD/.venv" ]]; then # use buitins over functions
		clone_if_not_exist "$UV_ENV" https://github.com/matthiasha/zsh-uv-env.git && source "$UV_ENV"
		_uv_env_loaded=1
		# REMOVE the hook after load to avoid repeated checks
		add-zsh-hook -d chpwd _uv_env_lazy_load 2>/dev/null
	fi
}

#  add-zsh-hook is available before registering
autoload -Uz add-zsh-hook
# lock the lazy load hook
add-zsh-hook chpwd _uv_env_lazy_load
#  check on initial shell load (dont forget!!)
_uv_env_lazy_load

function _prek_auto_install() {
	[[ -d .git && -f .pre-commit-config.yaml ]] || return 0

	local tool
	if command -v prek >/dev/null; then
		tool=prek
	elif command -v pre-commit >/dev/null; then
		tool=pre-commit
	else
		echo "prek or pre-commit not installed, you probably want it" >&2
		return 0
	fi

	# already installed by this tool? skip
	if [[ -f .git/hooks/pre-commit ]] && grep -q "$tool" .git/hooks/pre-commit 2>/dev/null; then
		return 0
	fi

	"$tool" install -f --hook-type pre-commit >/dev/null 2>&1
	return 0
}

add-zsh-hook chpwd _prek_auto_install
_prek_auto_install # also handle the directory the shell starts in

command -v shfmt >/dev/null && alias shellfmt='shfmt --write ~/.zshrc'
# for faster toy compilations

[[ $USER == alexc ]] && alias g++='g++ $(pkg-config --cflags --libs fmt)' || 0
#export RUSTFLAGS="-C target-cpu=native"
if ((_ZSH_DEBUG)); then
	zprof
fi
