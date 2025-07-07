#!/bin/bash

source ./utils.sh

if [[ "$WORK" == false ]]; then
  if [[ ! -f "$DOTFILES_DIR/modules/private/vault.yml" ]]; then
    echo "🚨 Private submodule required"
    echo "Generate SSH and GPG keys and add them to GitHub"
    echo "Then run: 'git submodule update --init --recursive'"
    exit 1
  fi

  read -sp "Vault password: " VAULT_PW
  echo

  VAULT_PW_FILE=$(mktemp)
  chmod 600 "$VAULT_PW_FILE"
  echo "$VAULT_PW" > "$VAULT_PW_FILE"

  ansible-playbook "$DOTFILES_DIR/main.yml" \
    -e "work_mode=$WORK" \
    -e "email=$EMAIL" \
    --vault-password-file "$VAULT_PW_FILE"
else
  ansible-playbook "$DOTFILES_DIR/main.yml" \
    -e "work_mode=$WORK" \
    -e "email=$EMAIL"
fi
