#!/bin/bash

PACMAN_PACKAGES+=(
  gimp
  libreoffice-fresh
  obsidian
  lazydocker
)

YAY_PACKAGES+=(
  google-chrome
)

if ! $WORK; then
  YAY_PACKAGES+=(
    brave-bin
    proton-vpn-gtk-app
    spotify
    1password-beta
    unityhub
  )

  PACMAN_PACKAGES+=(
    discord
    signal-desktop
  )
fi
