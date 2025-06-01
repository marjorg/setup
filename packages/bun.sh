#!/bin/bash

install() {
  execute eval "curl -fsSL https://bun.sh/install | bash"
}

update() {
  if ! command -v bun &> /dev/null; then
    log "🚨 Bun is not installed"
    exit 1
  fi

  # Check if Bun is already updated?
  execute bun upgrade
}
