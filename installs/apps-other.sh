#!/bin/bash

PACMAN_PACKAGES+=(
  gimp
  libreoffice-fresh
  obsidian
  lazydocker
)

YAY_PACKAGES+=(
  google-chrome
  brave-bin
  signal-desktop
)

if ! $WORK; then
  YAY_PACKAGES+=(
    proton-vpn-gtk-app
    spotify
    unityhub
  )

  PACMAN_PACKAGES+=(
    discord
    1password
  )
fi
