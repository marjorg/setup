#!/bin/bash

post_install() {
  if ! command -v bun &> /dev/null; then
    curl -fsSL https://bun.sh/install | bash
  fi

  if [ ! -f "$HOME/.config/nvm/nvm.sh" ]; then
    curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
  fi

  # Make available in current script
  export NVM_DIR="$HOME/.config/nvm"
  source "$NVM_DIR/nvm.sh"

  if ! nvm ls --no-alias | grep -q '\->'; then
    nvm install --lts
  fi
}
