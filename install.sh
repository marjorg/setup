#!/bin/bash

set -e
set -o pipefail

DRY=false
DEBUG=false

DOTFILES_DIR="$HOME/dotfiles"
IS_MAC=$(uname -s | grep -q Darwin && echo true || echo false)
IS_LINUX=$(uname -s | grep -q Linux && echo true || echo false)

while [[ $# > 0 ]]; do
  if [[ $1 == "--dry" ]]; then
    DRY=true
  elif [[ $1 == "--debug" ]]; then
    DEBUG=true
  fi

  shift
done

if $IS_MAC; then
  pre_setup_mac
elif $IS_LINUX; then
  echo ""
else
  echo "🚨 Unsupported OS"
  exit 1
fi

if ! [[ -d "$DOTFILES_DIR" ]]; then
  execute git clone --quiet https://github.com/marjorg/setup.git $DOTFILES_DIR
  echo "✅ Cloned repository"
else
  for file in "$DOTFILES_DIR/scripts/"*; do
    if [ -f "$file" ]; then
      source "$file"
    fi
  done

  if [ -z "$(git -C $DOTFILES_DIR status --porcelain)" ]; then
    execute git -C $DOTFILES_DIR pull --quiet
    log "✅ Updated repository"
  else
    debug "⚠️ Local changes detected in dotfiles repository, skipping pull"
  fi
fi

if ! execute op account get >/dev/null 2>&1; then
  log "Sign in to 1Password CLI"
  execute eval "$(op signin)"
  log "✅ Signed in to 1Password CLI"
fi

SSH_PASS=$(execute capture get_op_password zt523aidyr72aidluibpvs5zxy)
ENV_PASS=$(execute capture get_op_password o5pckyjgmw7y5v4clccfhrq2ky)
GPG_PASS=$(execute capture get_op_password i3uhsfzvqjtgxx2iqszjkv6hri)

execute ansible-playbook "$DOTFILES_DIR/main.yml" \
  --vault-id=ssh@<(echo "$SSH_PASS") \
  --vault-id=env@<(echo "$ENV_PASS") \
  --vault-id=gpg@<(echo "$GPG_PASS")

if $IS_MAC; then
  setup_mac
  post_setup_mac
fi
