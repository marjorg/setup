#!/bin/bash

EMAIL="${1}"

KEY_ID=$(gpg --list-secret-keys --with-colons "$EMAIL" 2>/dev/null | awk -F: '/^sec:/ {print $5}' | tail -n1)

if [[ -z "$KEY_ID" ]]; then
  echo "No GPG key found for email: $EMAIL" >&2
  exit 1
fi

echo "$KEY_ID"
