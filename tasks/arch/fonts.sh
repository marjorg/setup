#!/bin/bash

install() {
  fc-cache -f -v
}

update() {
  mkdir -p $HOME/.fonts/JetBrainsMono
  curl -LO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz
  tar -xf JetBrainsMono.tar.xz -C $DOTFILES_DIR/.fonts/JetBrainsMono
  rm JetBrainsMono.tar.xz
  fc-cache -f -v
}
