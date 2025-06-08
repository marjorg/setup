#!/bin/bash

# https://ghostty.org/docs/install/binary#ubuntu
install() {
  if command -v ghostty &> /dev/null; then
    return
  fi

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

  execute curl -L "$url" -o "$temp_deb"
  execute sudo dpkg -i "$temp_deb"
  execute rm -f "$temp_deb"
}
