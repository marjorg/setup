#!/bin/bash

get_op_password() {
  local VAULT_ID="$1"

  if [ -z "$VAULT_ID" ]; then
    log "Error: No vault ID provided"
    return 1
  fi

  execute op item get "$VAULT_ID" --fields password --reveal
  return $?
}
