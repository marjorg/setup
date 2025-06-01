#!/bin/bash

install_apt() {
  local pkg_id="$1"

  if ! dpkg -s "$pkg_id" &>/dev/null; then
    execute sudo apt-get install -y "$pkg_id"
    log "✅ Installed $pkg_id"
  else
    debug "Skipping APT package $pkg_id"
  fi
}
