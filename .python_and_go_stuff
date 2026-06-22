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

if command -v go-gitmoji-cli >/dev/null; then
	lazy_load_completion_on_first_use "go-gitmoji-cli" "go-gitmoji-cli completion zsh"
	alias gitmoji="go-gitmoji-cli"
fi

if command -v fzf >/dev/null; then

	source <(fzf --zsh)

fi


if command -v helix >/dev/null; then
	alias hx='helix'
fi



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