#!/bin/bash

TPM="${HOME}/.tmux/plugins/tpm"

install() {
  curl -fsSL https://apt.cli.rs/pubkey.asc | sudo tee -a /usr/share/keyrings/rust-tools.asc
  curl -fsSL https://apt.cli.rs/rust-tools.list | sudo tee /etc/apt/sources.list.d/rust-tools.list

  curl -s https://ohmyposh.dev/install.sh | bash -s
}

update() {
  execute oh-my-posh upgrade
}
