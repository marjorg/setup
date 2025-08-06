#!/bin/bash

PACMAN_PACKAGES+=(
  ntfs-3g # Full NTFS read/write support on drives shared with Windows
  nvidia-settings # For GPU tweaking
  lib32-nvidia-utils # For 32-bit game compatibility
  vulkan-tools # Vulkan support
  gamemode # Optimise Linux system performance on demand, requires setting launch options in Steam `gamemoderun %command%`
  mangohud # Overlay for monitoring FPS++, requires setting launch options in Steam `mangohud %command%`
  goverlay # GUI to customize mangohud
  playerctl # Media keys
  blueberry # Bluetooth GUI
  bluez # Bluetooth
  bluez-utils # Bluetooth
)
