#!/bin/bash

LATEST_VERSION=$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases | \
  jq -r '[.[] | select(.prerelease == false)][0].tag_name')

install() {
  export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

  execute eval "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$LATEST_VERSION/install.sh | bash"
  execute nvm install --lts
  execute nvm use --lts
}

update() {
  install
}
