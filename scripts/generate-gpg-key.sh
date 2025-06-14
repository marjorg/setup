#!/bin/bash

EMAIL="${1}"

# Only have one key per email
if gpg --list-secret-keys --with-colons "$EMAIL" | grep -q '^sec:'; then
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

KEY_ID=$(gpg --list-secret-keys --with-colons | grep '^sec:' | cut -d: -f5 | tail -n1)
echo "GPG key generated with ID: $KEY_ID"

gpg --armor --export "$KEY_ID"
