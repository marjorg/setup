#!/bin/bash

install() {
  sudo apt-get install -y btop \
    fd-find \
    fzf \
    gcc \
    neovim \
    protobuf-compiler \
    ripgrep \
    tmux \
    zsh \
    imagemagick

  curl -fsS https://dl.brave.com/install.sh | sh
  curl -fsSL https://bun.sh/install | bash
  curl -f https://zed.dev/install.sh | sh
}

update() {
  # Check if Bun is already updated?
  bun upgrade
}
