#!/bin/bash

source utils.sh

if [[ "$IS_ARCH" == true ]]; then
  execute sudo pacman -S archlinux-keyring --noconfirm
  execute sudo pacman -Syu --noconfirm
  execute sudo pacman -Fy --noconfirm

  if command -v yay &> /dev/null; then
    execute yay -Syu --noconfirm
  fi

  if command -v fwupdmgr &> /dev/null; then
    execute fwupdmgr refresh --force
    execute fwupdmgr update
  fi
fi

if [[ "$IS_ARCH" == true ]]; then
  mapfile -t orphans < <(pacman -Qtdq 2>/dev/null)
  if [[ ${#orphans[@]} -gt 0 ]]; then
    execute sudo pacman -Rns --noconfirm "${orphans[@]}"
  fi
  execute sudo pacman -Sc --noconfirm
fi

find $HOME/.local/share/Trash -type f -delete
