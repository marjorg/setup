#!/bin/bash

YAY_PACKAGES+=(
  visual-studio-code-bin
  sublime-text-4
  tableplus
  postman-bin
  hoppscotch-bin
  redisinsight-bin
)

PACMAN_PACKAGES+=(
  zed
  intellij-idea-community-edition
)

if ! $WORK; then
  YAY_PACKAGES+=(
    rider
  )
fi
