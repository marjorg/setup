#!/bin/bash

YAY_PACKAGES+=(
  google-chrome
  visual-studio-code-bin
  signal-desktop
  obsidian
)

PACMAN_PACKAGES+=(
  ghostty
)

# If not work mode
YAY_PACKAGES+=(
  1password
)

PACMAN_PACKAGES+=(
  discord
  spotify-launcher
  steam
)
# End if not work

post_install() {
  if ! command -v zed &> /dev/null; then
    curl -fsS https://zed.dev/install.sh | sh
  fi

  if ! command -v brave &> /dev/null; then
    curl -fsS https://dl.brave.com/install.sh | sh
  fi
}
