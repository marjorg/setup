#!/bin/bash

install() {
  if [[ -d "$HOME/.fonts/JetBrainsMono" ]]; then
    return
  fi

  mkdir -p $HOME/.fonts/JetBrainsMono
  curl -LO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz
  tar -xf JetBrainsMono.tar.xz -C $HOME/.fonts/JetBrainsMono
  rm JetBrainsMono.tar.xz
  fc-cache -f -v
}

update() {
  mkdir -p $HOME/.fonts/JetBrainsMono
  curl -LO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz
  tar -xf JetBrainsMono.tar.xz -C $HOME/.fonts/JetBrainsMono
  rm JetBrainsMono.tar.xz
  fc-cache -f -v
}
