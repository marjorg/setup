#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh" "$@"

set -euo pipefail

require_identity

# Only have one key per email
if [[ -n "$(gpg_key_id "$EMAIL")" ]]; then
  debug "GPG key already exists for $EMAIL"
  exit 0
fi

BATCH_FILE=$(mktemp)
trap 'rm -f "$BATCH_FILE"' EXIT

cat >"$BATCH_FILE" <<EOF
Key-Type: RSA
Key-Length: 4096
Subkey-Type: RSA
Subkey-Length: 4096
Name-Real: $NAME
Name-Email: $EMAIL
Expire-Date: 0
%no-protection
%commit
EOF

execute gpg --batch --generate-key "$BATCH_FILE"

KEY_ID=$(gpg_key_id "$EMAIL")
log "GPG key generated with ID: $KEY_ID"

gpg --armor --export "$KEY_ID"
