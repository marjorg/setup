#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh" "$@"

set -euo pipefail

KEY_PATH="$HOME/.ssh/id_ed25519"

if [ ! -f "$KEY_PATH" ]; then
  execute ssh-keygen -t ed25519 -C "$EMAIL" -f "$KEY_PATH" -N ""
  log "SSH key generated: $KEY_PATH"
fi

if [ -n "${SSH_AUTH_SOCK:-}" ] && ssh-add -l &>/dev/null; then
  if ! ssh-add -l 2>/dev/null | grep -q "$KEY_PATH"; then
    execute ssh-add "$KEY_PATH" 2>/dev/null
    debug "SSH key added to agent: $KEY_PATH"
  fi
else
  debug "No SSH agent running, key will be loaded on first use"
fi
