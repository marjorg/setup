#!/bin/bash

if [[ "$SWAY" == true ]]; then
  PACMAN_PACKAGES+=(
    wofi # App launcher
    swaylock
    swayidle
    wlsunset
    mako # Notifications
    nwg-look # GTK settings editor
  )
fi
