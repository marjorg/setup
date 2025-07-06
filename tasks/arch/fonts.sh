#!/bin/bash

install() {
  sudo pacman -Sy --noconfirm --needed \
    noto-fonts \
    noto-fonts-cjk \
    noto-fonts-extra \
    ttf-font-awesome

  yay -Sy --noconfirm --needed ttf-apple-emoji

  fc-cache -f -v
}

update() {
  mkdir -p $HOME/.fonts/JetBrainsMono
  curl -LO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz
  tar -xf JetBrainsMono.tar.xz -C $DOTFILES_DIR/.fonts/JetBrainsMono
  rm JetBrainsMono.tar.xz
  fc-cache -f -v
}
