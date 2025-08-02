#!/bin/bash

if [[ "$WORK" == false ]]; then
  YAY_PACKAGES+=(
    protonup-qt
    heroic-games-launcher-bin
    minecraft-launcher
  )

  PACMAN_PACKAGES+=(
    steam
    lutris
    wine
    wine-gecko
    wine-mono
    winetricks
  )
fi
