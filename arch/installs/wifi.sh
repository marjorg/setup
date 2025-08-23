#!/bin/bash

PACMAN_PACKAGES+=(
  network-manager-applet
)

post_install() {
  sudo systemctl enable --now NetworkManager
}

# TODO: Make sure sway shows applet
