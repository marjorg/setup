#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh" "$@"

set -euo pipefail

require_identity

KEY_ID=$(gpg_key_id "$EMAIL")

if [ -z "$KEY_ID" ]; then
  log "No GPG key found for email: $EMAIL"
  exit 1
fi

gpg --armor --export "$KEY_ID" | wl-copy
