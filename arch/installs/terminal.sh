#!/bin/bash

PACMAN_PACKAGES+=(
  rustup
)

post_install() {
  rustup default stable
}
