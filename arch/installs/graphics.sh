#!/bin/bash

if [[ "$NVIDIA" == true ]]; then
  PACMAN_PACKAGES+=(
    nvidia-settings # For GPU tweaking
    lib32-nvidia-utils # For 32-bit game compatibility
    vulkan-tools # Vulkan support
  )
fi

if [[ "$SWAY" == true ]]; then
  YAY_PACKAGES+=(
    wdisplays
  )
fi
