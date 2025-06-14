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
    zoxide

  curl -s https://ohmyposh.dev/install.sh | bash -s
}
