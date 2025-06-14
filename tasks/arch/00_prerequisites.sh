#!/bin/bash

install() {
  sudo pacman -Sy --noconfirm --needed curl \
    gnupg \
    ansible \
    unzip \
    openssh \
    jq \
    base-devel
    # Note: gnupg2 is provided by gnupg in Arch, so no need to install separately

    if ! command -v yay &> /dev/null; then
      git clone https://aur.archlinux.org/yay-bin.git
      cd yay-bin
      makepkg -si
    fi
}
