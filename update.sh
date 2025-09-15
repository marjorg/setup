#!/bin/bash

source utils.sh

if [[ "$IS_UBUNTU" == true ]]; then
  execute sudo apt-get update
  execute sudo apt-get upgrade -y
elif [[ "$IS_ARCH" == true ]]; then
  execute sudo pacman -S archlinux-keyring --noconfirm
  execute sudo pacman -Syu --noconfirm
fi

if [[ "$IS_UBUNTU" == true ]]; then
  execute sudo apt-get autoremove
  execute sudo apt-get autoclean
elif [[ "$IS_ARCH" == true ]]; then
  mapfile -t orphans < <(pacman -Qtdq 2>/dev/null)
  if [[ ${#orphans[@]} -gt 0 ]]; then
    execute sudo pacman -Rns --noconfirm "${orphans[@]}"
  fi
  execute sudo pacman -Sc --noconfirm
fi

find $HOME/.local/share/Trash -type f -delete
