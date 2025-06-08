#!/bin/bash

set -e
set -o pipefail

source shared.sh

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
