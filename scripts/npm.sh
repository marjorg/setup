#!/bin/bash

install_npm() {
  local pkg_id="$1"

  if ! npm list -g "$pkg_id" &>/dev/null; then
    execute npm install -g "$pkg_id"
    log "✅ Installed $pkg_id"
  else
    debug "Skipping npm package $pkg_id"
  fi
}
