#!/bin/bash

install_brew() {
  if [[ "$IS_MAC" == "false" ]]; then
    return
  fi

  local pkg_id="$1"

  if ! brew list --formula "$pkg_id" &>/dev/null; then
    execute brew install "$pkg_id"
    log "✅ Installed $pkg_id"
  else
    debug "Skipping formula $pkg_id"
  fi
}

upgrade_brew() {
  if [[ "$IS_MAC" == "false" ]]; then
    return
  fi

  local pkg_id="$1"

  if ! brew list --formula "$pkg_id" &>/dev/null; then
    execute brew upgrade "$pkg_id"
  else
    debug "Skipping formula $pkg_id"
  fi
}

install_brew_cask() {
  if [[ "$IS_MAC" == "false" ]]; then
    return
  fi

  local pkg_id="$1"

  if ! brew list --cask "$pkg_id" &>/dev/null; then
    execute brew install --cask "$pkg_id"
    log "✅ Installed $pkg_id"
  else
    debug "Skipping cask $pkg_id"
  fi
}
