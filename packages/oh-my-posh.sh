#!/bin/bash

install() {
  if command -v oh-my-posh &> /dev/null; then
    return
  fi

  install_brew jandedobbeleer/oh-my-posh/oh-my-posh

  if [[ "$IS_LINUX" == true ]]; then
    execute eval "curl -s https://ohmyposh.dev/install.sh | bash -s"
  fi
}

update() {
  if ! command -v oh-my-posh &> /dev/null; then
    log "🚨 Oh My Posh is not installed"
    exit 1
  fi

  if [[ "$IS_LINUX" == true ]]; then
    execute oh-my-posh upgrade
  fi
}
