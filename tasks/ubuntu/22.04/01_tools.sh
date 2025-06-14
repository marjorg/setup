#!/bin/bash

install() {
  sudo apt-get install -y curl \
    ansible \
    btop \
    btop \
    fd-find \
    fzf \
    gcc \
    gnupg \
    gnupg2 \
    imagemagick \
    jq \
    neovim \
    protobuf-compiler \
    ripgrep \
    tmux \
    unzip \
    zsh

  curl -fsS https://dl.brave.com/install.sh | sh
  curl -fsSL https://bun.sh/install | bash
  curl -f https://zed.dev/install.sh | sh
}

update() {
  # Check if Bun is already updated?
  bun upgrade
}
