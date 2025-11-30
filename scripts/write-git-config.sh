#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

set -euo pipefail

KEY_ID=$(gpg --list-secret-keys --with-colons "$EMAIL" 2>/dev/null | awk -F: '/^sec:/ {print $5}' | head -n1)

if [[ -z "$KEY_ID" ]]; then
  echo "No GPG key found for email: $EMAIL" >&2
  exit 1
fi

export git_signing_key=$KEY_ID
export git_user_email=$EMAIL
export git_gpg_program=$(which gpg)

mkdir -p "$HOME/.config/git"
gomplate -f "$HOME/dotfiles/templates/git_config.tmpl" -o "$HOME/.config/git/config"
