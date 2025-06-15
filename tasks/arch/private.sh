#!/bin/bash

install() {
  if [[ ! "$WORK" == true ]]; then
    sudo pacman -Sy --noconfirm --needed discord \
      spotify-launcher \
      steam
  fi
}
