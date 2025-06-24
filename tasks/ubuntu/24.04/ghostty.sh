#!/bin/bash

install() {
  local ubuntu_version
  ubuntu_version=$(lsb_release -rs)

  local url
  url=$(curl -s https://api.github.com/repos/mkasberg/ghostty-ubuntu/releases | \
    jq -r --arg ver "$ubuntu_version" '
      [.[] | select(.prerelease == false)][0].assets[]
      | select(.name | test("^ghostty_.*_amd64_" + ($ver | gsub("\\."; "\\.")) + "\\.deb$"))
      | .browser_download_url')

  echo "$url"
  local temp_deb
  temp_deb=$(mktemp --suffix=.deb)

  curl -L "$url" -o "$temp_deb"
  sudo dpkg -i "$temp_deb"
  rm -f "$temp_deb"
}
