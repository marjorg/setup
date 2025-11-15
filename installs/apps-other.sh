#!/bin/bash

YAY_PACKAGES+=(
  google-chrome
)

PACMAN_PACKAGES+=(
  gimp
)

if ! $WORK; then
  YAY_PACKAGES+=(
    brave-bin
    proton-vpn-gtk-app
  )

  PACMAN_PACKAGES+=(
    discord
  )
fi
