#!/bin/bash

PACMAN_PACKAGES+=(
  noto-fonts
  noto-fonts-cjk
  noto-fonts-extra
  ttf-font-awesome
  ttf-roboto # Microsoft sucks and has no sans-serif as fallback on some services
)

YAY_PACKAGES+=(
  ttf-apple-emoji
)

post_install() {
  fc-cache -f -v
}
