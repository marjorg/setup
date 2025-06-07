#!/bin/bash

install() {
  if command -v waybar &> /dev/null; then
    return
  fi

  if [[ "$IS_LINUX" == "true" ]]; then
    eecute sudo add-apt-repository ppa:nschloe/waybar
    execute sudo apt update
    install_apt waybar
  fi
}
