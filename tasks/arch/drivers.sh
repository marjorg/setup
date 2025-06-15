#!/bin/bash

install() {
  # Video
  sudo pacman -Sy --noconfirm --needed nvidia \
    nvidia-utils

  # Audio
  sudo pacman -Sy --noconfirm --needed pipewire \
    pipewire-audio \
    pipewire-pulse \
    pipewire-alsa \
    wireplumber
  # Not as root!
  systemctl --user enable pipewire pipewire-pulse wireplumber
  systemctl --user start pipewire pipewire-pulse wireplumber

  sudo pacman -Sy --noconfirm --needed power-profiles-daemon python-gobject
  sudo systemctl enable --now power-profiles-daemon.service

  sudo pacman -Sy --noconfirm --needed ufw
  # sudo systemctl enable --now ufw
  # sudo ufw enable
}
