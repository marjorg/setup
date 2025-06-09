#!/bin/bash

install() {
  if command -v brave-browser &> /dev/null; then
    return
  fi

  if [[ "$IS_LINUX" == "true" ]]; then
    execute eval "curl -fsS https://dl.brave.com/install.sh | sh"
  fi

  install_brew_cask brave-browser
}
