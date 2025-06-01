#!/bin/bash

install() {
  if command -v lazygit &> /dev/null; then
    return
  fi

  execute go install github.com/jesseduffield/lazygit@latest
}

update() {
  if ! command -v lazygit &> /dev/null; then
    log "🚨 Lazygit is not installed"
    exit 1
  fi

  execute go install github.com/jesseduffield/lazygit@latest
}
