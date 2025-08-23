#!/bin/bash

PACMAN_PACKAGES+=(
  ufw # Firewall
  gufw # UFW GUI
)

post_install() {
  sudo systemctl enable --now ufw.service

  sudo ufw default deny incoming
  sudo ufw default allow outgoing
  sudo ufw enable

  sudo systemctl enable ufw
  sudo systemctl start ufw
}

# TODO: gufw not working?
