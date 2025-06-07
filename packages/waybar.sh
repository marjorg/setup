#!/bin/bash

install() {
  if command -v waybar &> /dev/null; then
    return
  fi

  if [[ "$IS_LINUX" == "true" ]]; then
    install_apt waybar
  fi
}
