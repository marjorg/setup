#!/bin/bash

install() {
  yay -Sy --noconfirm --needed google-chrome 1password visual-studio-code-bin

  sudo pacman -Sy --noconfirm --needed zed
  if ! command -v zed &> /dev/null; then
    sudo ln -s /usr/bin/zeditor /usr/local/bin/zed
  fi

  if ! command -v brave &> /dev/null; then
    curl -fsS https://dl.brave.com/install.sh | sh
  fi

  if ! command -v bun &> /dev/null; then
    curl -fsSL https://bun.sh/install | bash
  fi
}
