#!/bin/bash

PACMAN_PACKAGES+=(
  blueberry # Bluetooth GUI
  bluez # Bluetooth
  bluez-utils # Bluetooth
)

post_install() {
  sudo systemctl enable --now bluetooth.service
}

# TODO: Applet?