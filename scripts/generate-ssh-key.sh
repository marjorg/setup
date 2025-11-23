#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

KEY_PATH="$HOME/.ssh/id_ed25519"

if [ ! -f "$KEY_PATH" ]; then
    ssh-keygen -t ed25519 -C "$EMAIL" -f "$KEY_PATH" -N ""
fi

eval "$(ssh-agent -s)"

ssh-add -l | grep -q "$KEY_PATH"
if [ $? -ne 0 ]; then
    ssh-add "$KEY_PATH"
fi

