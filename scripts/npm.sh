#!/bin/bash

install_npm() {
  local pkg_id="$1"
  local pkg_name="$2"

  if ! npm list -g "$pkg_id" &>/dev/null; then
    execute npm install -g "$pkg_id"
    log "✅ Installed $pkg_name"
  else
    debug "Skipping npm package $pkg_name"
  fi
}
