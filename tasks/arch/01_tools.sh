#!/bin/bash

install() {
  sudo pacman -Sy --noconfirm --needed btop \
    fd \
    fzf \
    gcc \
    gnupg \
    imagemagick \
    neovim \
    protobuf \
    ripgrep \
    tmux \
    zsh \
    zoxide \
    xdg-user-dirs

  if [[ -d "$HOME/Desktop" ]]; then
    xdg-user-dirs-update
  fi

  if ! command -v oh-my-posh &> /dev/null; then
    curl -s https://ohmyposh.dev/install.sh | bash -s
  fi
}
