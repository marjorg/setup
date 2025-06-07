#!/bin/bash

setup_linux() {
  if ! [ -x "$(command -v jq)" ]; then
    sudo apt-get install jq -y
    log "✅ Installed jq"
  fi

  if ! [ -x "$(command -v unzip)" ]; then
    sudo apt-get install unzip -y
    log "✅ Installed unzip"
  fi

  if ! [ -x "$(command -v op)" ]; then
    curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
      sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg && \
      echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" | \
      sudo tee /etc/apt/sources.list.d/1password.list && \
      sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/ && \
      curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | \
      sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol && \
      sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22 && \
      curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
      sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg && \
      sudo apt update && sudo apt install 1password-cli
      log "✅ Installed 1Password CLI"
  fi

  if ! [ -x "$(command -v ansible)" ]; then
    sudo apt-get install ansible -y
    log "✅ Installed Ansible"
  fi

  log "✅ Completed Linux setup"
}
