#!/bin/bash

install_mas_app() {
  local app_id="$1"
  local app_name="$2"

  if ! mas list | grep -q "^${app_id} "; then
    execute mas install "$app_id"
    log "✅ Installed MAS $app_name"
  else
    debug "Skipping MAS $app_name"
  fi
}
