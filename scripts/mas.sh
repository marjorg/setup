#!/bin/bash

install_mas() {
  if [[ "$IS_MAC" == "false" ]]; then
    return
  fi

  local app_id="$1"

  if ! mas list | grep -q "^${app_id} "; then
    execute mas install "$app_id"
    log "✅ Installed MAS $app_id"
  else
    debug "Skipping MAS $app_id"
  fi
}
