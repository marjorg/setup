#!/bin/bash

install() {
  if command -v oha &> /dev/null; then
    return
  fi

  if [[ "$IS_MAC" == true ]]; then
    install_brew oha
  elif [[ "$IS_LINUX" == true ]]; then
    execute echo "deb [signed-by=/usr/share/keyrings/azlux-archive-keyring.gpg] http://packages.azlux.fr/debian/ stable main" | sudo tee /etc/apt/sources.list.d/azlux.list
    execute sudo curl -fsSL https://azlux.fr/repo.gpg -o /usr/share/keyrings/azlux-archive-keyring.gpg
    execute sudo apt update
    install_apt oha
  fi
}

update() {
  if ! command -v oha &> /dev/null; then
    log "🚨 OHA is not installed"
    exit 1
  fi
}
