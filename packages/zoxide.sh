#!/bin/bash

install() {
  if command -v zoxide &> /dev/null; then
    return
  fi

  if [[ "$IS_LINUX" == true ]]; then
    execute eval curl -fsSL https://apt.cli.rs/pubkey.asc | sudo tee -a /usr/share/keyrings/rust-tools.asc
    execute eval curl -fsSL https://apt.cli.rs/rust-tools.list | sudo tee /etc/apt/sources.list.d/rust-tools.list
    execute sudo apt-get update
  fi

  install_brew zoxide
  install_apt zoxide
}
