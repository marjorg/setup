#!/bin/bash

YAY_PACKAGES+=(
  visual-studio-code-bin
  tableplus
  postman-bin
  hoppscotch-bin
  lazydocker
  redisinsight-bin
)

PACMAN_PACKAGES+=(
  neovim
  lazygit
)

post_install() {
  if ! command -v zed &> /dev/null; then
    curl -fsS https://zed.dev/install.sh | sh
  fi
}
