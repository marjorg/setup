#!/bin/bash

PACMAN_PACKAGES+=(
  go
)

post_install() {
  go install golang.org/x/tools/gopls@latest
  # TODO: Add other tools
}
