#!/bin/bash

install() {
  if command -v zoxide &> /dev/null; then
    return
  fi

  if [[ "$IS_MAC" == true ]]; then
    install_brew zoxide
  elif [[ "$IS_LINUX" == true ]]; then
    execute eval curl -fsSL https://apt.cli.rs/pubkey.asc | sudo tee -a /usr/share/keyrings/rust-tools.asc
    execute eval curl -fsSL https://apt.cli.rs/rust-tools.list | sudo tee /etc/apt/sources.list.d/rust-tools.list
    execute sudo apt update
    install_apt zoxide
  fi
}

update() {
  if ! command -v zoxide &> /dev/null; then
    log "🚨 'Zoxide is not installed"
    exit 1
  fi
}
