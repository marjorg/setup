#!/bin/bash

install() {
  if command -v zed &> /dev/null; then
    return
  fi
  
  execute curl -f https://zed.dev/install.sh | sh
}

update() {
  if ! command -v zed &> /dev/null; then
    log "🚨 'Zed is not installed"
    exit 1
  fi

  execute curl -f https://zed.dev/install.sh | sh
}
