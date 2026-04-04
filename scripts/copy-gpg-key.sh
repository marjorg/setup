#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh" "$@"

set -euo pipefail

KEY_ID=$(gpg --list-secret-keys --with-colons "$EMAIL" | grep '^sec:' | cut -d: -f5 | head -n1)

if [ -z "$KEY_ID" ]; then
  log "No GPG key found for email: $EMAIL"
  exit 1
fi

gpg --armor --export "$KEY_ID" | wl-copy
