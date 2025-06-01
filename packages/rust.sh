#!/bin/bash

install() {
  if command -v rustup &> /dev/null; then
    return
  fi

  execute eval "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y"
}

update() {
  if ! command -v rustc &> /dev/null; then
    log "🚨 Rust is not installed"
    exit 1
  fi

  execute rustup update
}
