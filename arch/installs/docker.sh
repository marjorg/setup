#!/bin/bash

PACMAN_PACKAGES+=(
  docker
  docker-compose
)

post_install() {
  sudo systemctl start docker
  sudo systemctl enable docker
  sudo usermod -aG docker $USER
}