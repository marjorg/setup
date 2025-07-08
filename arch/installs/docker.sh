#!/bin/bash

PACMAN_PACKAGES+=(
  docker
  qemu
  # Viritualization, you probably also have to change some settings in BIOS.
  libvirt
  virt-manager
)

YAY_PACKAGES+=(
  docker-desktop
)

post_install() {
  sudo systemctl start docker
  sudo systemctl enable docker
  sudo usermod -aG docker $USER
}
