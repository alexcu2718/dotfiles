export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"

autoload -U compinit
compinit


zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh
zstyle ':completion:*' list-lines 10

fpath+=/usr/share/zsh/vendor-completions
fpath+=~/.zsh/completions 


function refresh_zshrc() {
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

source "$ZSH/oh-my-zsh.sh"
zstyle ':omz:update' mode auto      # update automatically without asking
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_LS_COLORS="false"
DISABLE_AUTO_TITLE="true"
ENABLE_CORRECTION="true"
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# COMPLETION_WAITING_DOTS="true"
plugins=(gitfast  archlinux github   pip
 gh fzf  systemd sudo eza  starship tldr  copyfile
   uv  ufw vscode  z  rust python
 )

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source $ZSH/plugins/autoenv/autoenv.plugin.zsh
source ~/.shell_functions
unset zle_bracketed_paste
source ~/.bindkeys
