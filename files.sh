#!/bin/bash

set -e
set -o pipefail

source shared.sh

read -sp "Vault password: " VAULT_PW
echo

VAULT_PW_FILE=$(mktemp)
chmod 600 "$VAULT_PW_FILE"
echo "$VAULT_PW" > "$VAULT_PW_FILE"

ansible-playbook "$DOTFILES_DIR/main.yml" \
  -e "work_mode=$WORK" \
  --vault-password-file "$VAULT_PW_FILE"

if [[ "$IS_LINUX" == true ]]; then
  if [[ "$SHELL" != "/usr/bin/zsh" ]]; then
    execute chsh -s $(which zsh)
    log "Changed default shell to zsh, restart terminal"
  else
    debug "Default shell is already zsh"
  fi
fi
