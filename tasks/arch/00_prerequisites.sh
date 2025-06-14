#!/bin/bash

install() {
  sudo pacman -Sy --noconfirm --needed curl \
    gnupg \
    ansible \
    unzip \
    openssh \
    jq
  # Note: gnupg2 is provided by gnupg in Arch, so no need to install separately
}
