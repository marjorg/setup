#!/bin/bash

install() {
  if [[ "$IS_LINUX" == "true" ]]; then
    if [[ -d "$HOME/.fonts/JetBrainsMono" ]]; then
      return
    fi

    execute mkdir -p $HOME/.fonts/JetBrainsMono
    execute eval "curl -LO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz"
    execute tar -xf JetBrainsMono.tar.xz -C $HOME/.fonts/JetBrainsMono
    execute rm JetBrainsMono.tar.xz
    execute fc-cache -f -v
  fi

  install_brew_cask font-jetbrains-mono
  install_brew_cask font-jetbrains-mono-nerd-font
}

update() {
  if [[ "$IS_LINUX" == "true" ]]; then
    execute mkdir -p $HOME/.fonts/JetBrainsMono
    execute eval "curl -LO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz"
    execute tar -xf JetBrainsMono.tar.xz -C $HOME/.fonts/JetBrainsMono
    execute rm JetBrainsMono.tar.xz
    execute fc-cache -f -v
  fi
}
