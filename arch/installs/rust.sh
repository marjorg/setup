#!/bin/bash

PACMAN_PACKAGES+=(
  rustup
)

post_install() {
  # TODO: Somehow check if already latest?
  rustup default stable
}
