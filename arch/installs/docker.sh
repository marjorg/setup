#!/bin/bash

pre_install() {
  if command -v docker-compose &>/dev/null; then
    execute yay -R --noconfirm docker-compose docker-buildx
  fi
}

YAY_PACKAGES+=(
  docker-desktop
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
