#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

set -euo pipefail

DOTFILES_HOME="$HOME/dotfiles/home"
DOTFILES_CONFIG="$HOME/dotfiles/home/.config"
HOME_CONFIG="$HOME/.config"

link() {
  local src=$1
  local dest=$2

  mkdir -p "$(dirname "$dest")"
  ln -sf "$src" "$dest"
  echo "Linked: $dest → $src"
}

link "$DOTFILES_HOME/.zshrc" "$HOME/.zshrc"
link "$DOTFILES_HOME/.profile" "$HOME/.profile"

link "$DOTFILES_CONFIG/Code/User/keybindings.json" "$HOME_CONFIG/Code/User/keybindings.json"
link "$DOTFILES_CONFIG/Code/User/settings.json" "$HOME_CONFIG/Code/User/settings.json"
link "$DOTFILES_CONFIG/omarchy/branding/screensaver.txt" "$HOME_CONFIG/omarchy/branding/screensaver.txt"

for d in "$DOTFILES_CONFIG"/*/; do
  folder=$(basename "$d")

  case "$folder" in
    Code|omarchy)
      continue
      ;;
  esac

  if [[ -L "$dest" ]]; then
    echo "Skip: $folder (already symlink)"
    continue
  fi

  if [[ -d "$dest" ]]; then
    echo "Skip: $folder is an existing directory (not replacing)"
    continue
  fi

  link "$d" "$dest"
done
