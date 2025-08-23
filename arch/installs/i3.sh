#!/bin/bash

if [[ "$I3" == true ]]; then
  PACMAN_PACKAGES+=(
    feh
    rofi
    redshift
    lxappearance
    flameshot
    sassc
    picom
    pamixer
    dunst
    arandr # Screen management GUI
    playerctl # Media keys
  )

  YAY_PACKAGES+=(
    i3-resurrect
    i3lock-color
  )
fi
