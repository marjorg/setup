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
}
