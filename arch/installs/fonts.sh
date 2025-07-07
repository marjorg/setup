#!/bin/bash

PACMAN_PACKAGES+=(
  noto-fonts
  noto-fonts-cjk
  noto-fonts-extra
  ttf-font-awesome
)

YAY_PACKAGES+=(
  ttf-apple-emoji
)

post_install() {
  fc-cache -f -v
}
