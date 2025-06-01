#!/bin/bash

set -e
set -o pipefail

IS_MAC=$(uname -s | grep -q Darwin && echo true || echo false)
IS_LINUX=$(uname -s | grep -q Linux && echo true || echo false)

if [[ "$IS_MAC" == "false" && "$IS_LINUX" == "false" ]]; then
  echo "🚨 Unsupported OS" >&2
  exit 1
fi

DOTFILES_DIR="$HOME/dotfiles"

if ! [[ -d "$DOTFILES_DIR" ]]; then
  git clone --quiet https://github.com/marjorg/setup.git $DOTFILES_DIR
  echo "✅ Cloned repository"
else
  source shared.sh

  if [ -z "$(git -C $DOTFILES_DIR status --porcelain)" ]; then
    execute git -C $DOTFILES_DIR pull --quiet
    log "✅ Updated repository"
  else
    log "⚠️ Local changes detected in dotfiles repository, skipping pull"
  fi

  if [[ "$IS_MAC" == true ]]; then
    setup_mac
    execute brew update
  elif [[ "$IS_LINUX" == true ]]; then
    setup_linux
    execute sudo apt-get update
  fi

  for pkg in "$PACKAGES_DIR"/*.sh; do
    if [[ -f "$pkg" ]]; then
      source "$pkg"
      name=$(basename "${pkg%.sh}")

      if declare -f install > /dev/null; then
        debug "Installing $name"
        install
        unset -f install
        log "✅ Installed $name"
      fi
    fi
  done

  if op whoami 2>&1 | grep -q "no account found"; then
    log "Please add 1pass account manually with op account add"
    exit 1
  else
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
fi
