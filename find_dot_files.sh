#!/usr/bin/env bash

cd "$(dirname "$0")"




exclude_names="jupyter|yarnrc|polars|tcsh|ipython|ipynb_checkpoints|omnissa|hyper|q3a|industry|godot|quarto|glib|vlc|racket|syncplay|kdedefaults|password-store|aspnet|rnd|virtual_documents|gitconfig|streamlit|valkeycli_history|redhat|z|java"


exclude_ext="db|js|zwc|save"


exclude_desktop="kde|gtk|desktop|plasma|akonadi|xfce4|thunar|deepin|gnome|kai|sway|wayland|xsettingsd|lxqt|lxde|mate|cinnamon|gnome|xfce|lxsession|kwin"

{

  du -h --max-depth=1 --exclude='.git' ~/.config | awk '$1 ~ /[Kk]/ { $1=""; sub(/^ /, ""); print }'


  find ~ -maxdepth 1 -name ".*" ! -name "." ! -name ".." \
    ! -path "$HOME/.config" ! -path "$HOME/.cache" \
    -exec du -h -s {} + | awk '$1 ~ /[Kk]/ { $1=""; sub(/^ /, ""); print }'
} | grep -E -v "\
/\.($exclude_names)(\.|$)|\
/\.($exclude_desktop)[^/]*|\
\.(($exclude_ext))$\
" > ./total_dot_files.txt

HOME_PREFIX="$HOME/"

while IFS= read -r item; do

  relpath="${item#$HOME_PREFIX}"

  echo "Copying $item to ./$relpath"


  mkdir -p "$(dirname "$relpath")"

  cp -r "$item" "$relpath"
done < total_dot_files.txt

rm .zcompdump* -rf

rm total_dot_files.txt

cp ~/.config/Code/User/settings.json ./vscode-settings.json

cp ~/.config/Code/User/keybindings.json ./keybindings.json

