#!/bin/bash

install_brew() {
  local pkg_id="$1"
  local pkg_name="$2"

  if ! brew list --formula "$pkg_id" &>/dev/null; then
    execute brew install "$pkg_id"
    log "✅ Installed $pkg_name"
  else
    debug "Skipping formula $pkg_name"
  fi
}

install_brew_cask() {
  local pkg_id="$1"
  local pkg_name="$2"

  if ! brew list --cask "$pkg_id" &>/dev/null; then
    execute brew install --cask "$pkg_id"
    log "✅ Installed $pkg_name"
  else
    debug "Skipping cask $pkg_name"
  fi
}
