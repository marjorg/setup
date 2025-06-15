#!/bin/bash

install() {
  yay -Sy --noconfirm --needed google-chrome visual-studio-code-bin signal-desktop obsidian

  sudo pacman -Sy --noconfirm --needed zed
  if ! command -v zed &> /dev/null; then
    sudo ln -s /usr/bin/zeditor /usr/local/bin/zed
  fi

  if ! command -v brave &> /dev/null; then
    curl -fsS https://dl.brave.com/install.sh | sh
  fi

  if [[ ! "$WORK" == true ]]; then
    yay -Sy --noconfirm --needed 1password

    sudo pacman -Sy --noconfirm --needed discord \
      spotify-launcher \
      steam
  fi
}
