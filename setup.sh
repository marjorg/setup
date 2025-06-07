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
SCRIPT_NAME=$(basename "$0")

if [[ "$0" != "$DOTFILES_DIR/$SCRIPT_NAME" && ! -d "$DOTFILES_DIR" ]]; then
  if ! [ -x "$(command -v git)" ]; then
    if [[ "$IS_MAC" == true ]]; then
      brew install git
    elif [[ "$IS_LINUX" == true ]]; then
      sudo apt-get install git -y
    fi

    log "✅ Installed Git"
  fi

  git clone --quiet https://github.com/marjorg/setup.git $DOTFILES_DIR
  echo "✅ Cloned repository"
  cd "$DOTFILES_DIR"
  ./setup.sh
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

      if declare -F install > /dev/null; then
        install
        unset -f install
      else
        debug "Skipping $name – no install function"
      fi
    fi
  done

  if ! jq -e '.accounts | length > 0' "$HOME/.config/op/config" >/dev/null 2>&1; then
    log "❌ No 1Password configuration found. Please run: op account add"
    exit 1
  else
    execute eval "$(op signin)"
    log "✅ Signed in to 1Password CLI"
  fi

  SSH_PASS=$(execute capture get_op_password zt523aidyr72aidluibpvs5zxy)
  ENV_PASS=$(execute capture get_op_password o5pckyjgmw7y5v4clccfhrq2ky)
  GPG_PASS=$(execute capture get_op_password i3uhsfzvqjtgxx2iqszjkv6hri)

  # Write to tempfile to avoid that pipe process can exit before Ansible reads it
  SSH_FILE=$(mktemp)
  ENV_FILE=$(mktemp)
  GPG_FILE=$(mktemp)

  echo "$SSH_PASS" > "$SSH_FILE"
  echo "$ENV_PASS" > "$ENV_FILE"
  echo "$GPG_PASS" > "$GPG_FILE"

  ansible-playbook "$DOTFILES_DIR/main.yml" \
      --vault-id="ssh@$SSH_FILE" \
      --vault-id="env@$ENV_FILE" \
      --vault-id="gpg@$GPG_FILE"

  shred -u "$SSH_FILE" "$ENV_FILE" "$GPG_FILE"

  if [[ "$IS_LINUX" == true ]]; then
    if [[ "$SHELL" != "/usr/bin/zsh" ]]; then
      execute chsh -s $(which zsh)
      log "Changed default shell to zsh, restart terminal"
    else
      debug "Default shell is already zsh"
    fi
  fi
fi
