#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

set -euo pipefail

# Only have one key per email
if gpg --list-secret-keys --with-colons "$EMAIL" | grep -q '^sec:'; then
  debug "GPG key already exists for $EMAIL"
  exit 0
fi

cat >gpg-batch <<EOF
Key-Type: RSA
Key-Length: 4096
Subkey-Type: RSA
Subkey-Length: 4096
Name-Real: Marius
Name-Email: $EMAIL
Expire-Date: 0
%no-protection
%commit
EOF

gpg --batch --generate-key gpg-batch
rm -f gpg-batch

KEY_ID=$(gpg --list-secret-keys --with-colons "$EMAIL" | grep '^sec:' | cut -d: -f5 | head -n1)
log "GPG key generated with ID: $KEY_ID"

gpg --armor --export "$KEY_ID"
