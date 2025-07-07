#!/bin/bash

PACMAN_PACKAGES+=(
  curl
  gnupg
  ansible
  unzip
  jq
)

pre_install() {
  if command -v yay &> /dev/null; then
    return
  fi

  sudo pacman -Sy --noconfirm --needed base-devel
  git clone https://aur.archlinux.org/yay-bin.git
  cd yay-bin
  makepkg -si
  cd ..
  rm -rf yay-bin
}
