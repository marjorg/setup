#!/bin/bash

if [[ "$SWAY" == true ]]; then
  PACMAN_PACKAGES+=(
    wofi # App launcher
    swaylock
    swayidle
    brightnessctl
    wlsunset
    mako # Notifications
    nwg-look # GTK settings editor
    # Screenshots
    grim
    slurp
    wl-clipboard
  )
fi
