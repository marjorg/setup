#!/bin/bash

install() {
  if [[ "$IS_WORK" != "true" ]]; then
    curl -sSL https://downloads.1password.com/linux/debian/amd64/stable/1password-latest.deb -o 1password-latest.deb
    sudo dpkg -i 1password-latest.deb
    rm -f 1password-latest.deb
  fi
}
