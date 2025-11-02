#!/bin/bash

DOTFILES_HOME="$HOME/dotfiles/home"
DOTFILES_CONFIG="$HOME/dotfiles/home/.config"
HOME_CONFIG="$HOME/.config"

ln -sf "$DOTFILES_HOME/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_HOME/.profile" "$HOME/.profile"

for d in "$DOTFILES_CONFIG"/*/; do
  folder=$(basename "$d")

  if [[ -L "$HOME_CONFIG/$folder" ]]; then
    continue
  elif [[ -d "$HOME_CONFIG/$folder" ]]; then
    echo "$folder is a folder, not symlinking"
    continue
  fi

  ln -sf "$DOTFILES_CONFIG/$folder" "$HOME_CONFIG/$folder"
done
