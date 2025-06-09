#!/bin/bash

LATEST_VERSION=$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases | \
  jq -r '[.[] | select(.prerelease == false)][0].tag_name')

install() {
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

  if command -v nvm &> /dev/null; then
    return
  fi

  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$LATEST_VERSION/install.sh | bash

  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

  nvm install --lts
  nvm use --lts
}

update() {
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

  if ! command -v nvm &> /dev/null; then
    log "🚨 NVM is not installed"
    exit 1
  fi

  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$LATEST_VERSION/install.sh | bash
  nvm install --lts
  nvm use --lts
}
