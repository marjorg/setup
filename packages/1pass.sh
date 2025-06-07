#!/bin/bash

install() {
  if command -v 1password &> /dev/null; then
    return
  fi

  if [[ "$IS_LINUX" == "true" ]]; then
    curl -sSL https://downloads.1password.com/linux/debian/amd64/stable/1password-latest.deb -o 1password-latest.deb
    sudo dpkg -i 1password-latest.deb
    rm -f 1password-latest.deb
  elif [[ "$IS_MACOS" == "true" ]]; then
    install_brew_cask 1password
  fi
}
