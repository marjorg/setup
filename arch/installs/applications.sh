#!/bin/bash

YAY_PACKAGES+=(
  google-chrome
  visual-studio-code-bin
  signal-desktop
  obsidian
  tableplus
  postman-bin
)

PACMAN_PACKAGES+=(
  ghostty
  gimp
  file-roller # Unzipper
)

if [[ "$WORK" == false ]]; then
  YAY_PACKAGES+=(
    1password
    proton-pass-bin
    proton-vpn-gtk-app
  )

  PACMAN_PACKAGES+=(
    discord
    spotify-launcher
  )
fi

post_install() {
  if ! command -v zed &> /dev/null; then
    curl -fsS https://zed.dev/install.sh | sh
  fi

  if ! command -v brave &> /dev/null; then
    curl -fsS https://dl.brave.com/install.sh | sh
  fi
}
