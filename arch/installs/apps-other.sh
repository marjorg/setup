#!/bin/bash

YAY_PACKAGES+=(
  google-chrome
  signal-desktop
  obsidian
)

PACMAN_PACKAGES+=(
  gimp
  # file-roller # Unzipper
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
  if ! command -v brave &> /dev/null; then
    curl -fsS https://dl.brave.com/install.sh | sh
  fi
}
