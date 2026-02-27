#!/bin/bash

PACMAN_PACKAGES+=(
  gimp
  libreoffice-fresh
  obsidian
  lazydocker
)

if ! $WORK; then
  YAY_PACKAGES+=(
    brave-bin
    proton-vpn-gtk-app
    spotify
    1password-beta
  )

  PACMAN_PACKAGES+=(
    discord
    signal-desktop
  )
fi
