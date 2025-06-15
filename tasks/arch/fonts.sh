#!/bin/bash

install() {
  sudo pacman -Sy --noconfirm --needed ttf-hack ttf-ubuntu-font-family ttf-dejavu noto-fonts ttf-liberation ttf-font-awesome
  fc-cache -f -v
}

update() {
  mkdir -p $HOME/.fonts/JetBrainsMono
  curl -LO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz
  tar -xf JetBrainsMono.tar.xz -C $DOTFILES_DIR/.fonts/JetBrainsMono
  rm JetBrainsMono.tar.xz
  fc-cache -f -v
}
