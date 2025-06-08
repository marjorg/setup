#!/bin/bash

# https://ghostty.org/docs/install/binary#ubuntu
install() {
  if command -v ghostty &> /dev/null; then
    return
  fi

  local url
  url=$(curl -sf "https://api.github.com/repos/mkasberg/ghostty-ubuntu/releases/latest" \
    | grep "browser_download_url.*deb" \
    | cut -d '"' -f 4)

  local temp_deb
  temp_deb=$(mktemp --suffix=.deb)

  execute curl -L "$url" -o "$temp_deb"
  execute sudo dpkg -i "$temp_deb"
  execute rm -f "$temp_deb"
}
