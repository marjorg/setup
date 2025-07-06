#!/bin/bash

install() {
  sudo apt install -y \
    fonts-noto \
    fonts-noto-cjk \
    fonts-noto-extra \
    fonts-font-awesome \
    fonts-emojione

  fc-cache -f -v
}

update() {
  mkdir -p $HOME/.fonts/JetBrainsMono
  curl -LO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz
  tar -xf JetBrainsMono.tar.xz -C $DOTFILES_DIR/.fonts/JetBrainsMono
  rm JetBrainsMono.tar.xz
  fc-cache -f -v
}
