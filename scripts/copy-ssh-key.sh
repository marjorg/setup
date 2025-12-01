#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

set -euo pipefail

KEY_PATH="$HOME/.ssh/id_ed25519.pub"

if [ ! -f "$KEY_PATH" ]; then
  log "SSH public key not found at: $KEY_PATH"
  exit 1
fi

wl-copy < "$KEY_PATH"
