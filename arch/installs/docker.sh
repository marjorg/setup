#!/bin/bash

PACMAN_PACKAGES+=(
  docker
  docker-compose
  docker-buildx
)

# post_install() {
  # TODO Make sure docker-desktop starts on startup
  # systemctl list-unit-files | grep docker-desktop
  # docker-desktop.service     disabled
  # sudo systemctl enable docker-desktop
  # sudo systemctl start docker-desktop
  # systemctl status docker
  # systemctl status docker-desktop
# }
