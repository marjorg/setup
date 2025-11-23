#!/bin/bash

SSH_DIR="$HOME/.ssh"
TEMPLATE="$HOME/dotfiles/templates/ssh_config.tmpl"
SSH_KNOWN_HOSTS="$SSH_DIR/known_hosts"
SSH_CONFIG="$SSH_DIR/config"

chmod 700 "$SSH_DIR"

gomplate -f "$TEMPLATE" -o "$SSH_CONFIG"
chmod 600 "$SSH_CONFIG"

touch "$SSH_KNOWN_HOSTS"
chmod 644 "$SSH_KNOWN_HOSTS"

HOSTS=("github.com")
for host in "${HOSTS[@]}"; do
  if ! ssh-keygen -F "$host" -f "$SSH_KNOWN_HOSTS" > /dev/null; then
    ssh-keyscan "$host" >> "$SSH_KNOWN_HOSTS" 2>/dev/null
  fi
done
