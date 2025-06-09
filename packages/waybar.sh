#!/bin/bash

install() {
  if command -v waybar &> /dev/null; then
    return
  fi

  install_apt waybar
}
