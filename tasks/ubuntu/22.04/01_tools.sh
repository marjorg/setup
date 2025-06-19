#!/bin/bash

install() {
  sudo apt-get install -y btop \
    fd-find \
    fzf \
    gcc \
    gnupg \
    gnupg2 \
    imagemagick \
    neovim \
    protobuf-compiler \
    ripgrep \
    tmux \
    zsh \
    zoxide
}

update() {
  # Check if Bun is already updated?
  bun upgrade
}
