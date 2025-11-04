
#!/bin/bash

# Unwanted exact names or prefixes (no leading dot)
exclude_names="jupyter|yarnrc|polars|tcsh|ipython|ipynb_checkpoints|omnissa|hyper|q3a|industry|godot|quarto|glib|vlc|racket|syncplay|kdedefaults"

# Unwanted file extensions (without dot)
exclude_ext="db|js|zwc|save"

# KDE/desktop environment and GUI-related prefixes/names
exclude_desktop="kde|gtk|desktop|plasma|akonadi|xfce4|thunar|deepin|gnome|kai|sway|wayland|xsettingsd|lxqt|lxde|mate|cinnamon|gnome|xfce|lxsession|kwin"

{
  # From ~/.config (under 1MB)
  du -h --max-depth=1 --exclude='.git' ~/.config | awk '$1 ~ /[Kk]/ { $1=""; sub(/^ /, ""); print }'

  # From ~ (exclude .config and .cache)
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
  # Strip home prefix to get relative path
  relpath="${item#$HOME_PREFIX}"

  echo "Copying $item to ./$relpath"

  # Make sure target directory exists
  mkdir -p "$(dirname "$relpath")"
  #making sure to quote properlyt cos of spaces...
  # Copy recursively (works for both files and directories)
  cp -r "$item" "$relpath"
done < total_dot_files.txt

##copy osx kvm files for macos emulation
command -v rsync && rsync -av --max-size=2m ~/OSX-KVM/ ./OSX-KVM
