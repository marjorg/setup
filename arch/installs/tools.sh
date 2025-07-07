#!/bin/bash

PACMAN_PACKAGES+=(
  btop
  fd
  fzf
  gcc
  gnupg
  imagemagick
  neovim
  protobuf
  ripgrep
  tmux
  zsh
  zoxide
  xdg-user-dirs
  man-db
  man-pages
)

post_install() {
  if [[ -d "$HOME/Desktop" ]]; then
    xdg-user-dirs-update
  fi

  if ! command -v oh-my-posh &> /dev/null; then
    curl -s https://ohmyposh.dev/install.sh | bash -s
  fi
}
