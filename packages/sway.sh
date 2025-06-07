#!/bin/bash

install() {
  if command -v sway &> /dev/null; then
    return
  fi

  if [[ "$IS_LINUX" == "true" ]]; then
    install_apt sway
  fi
}
