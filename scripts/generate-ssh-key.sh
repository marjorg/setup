#!/bin/bash

EMAIL=$1
KEY_PATH="$HOME/.ssh/id_ed25519"

if [ ! -f "$KEY_PATH" ]; then
  ssh-keygen -t ed25519 -C "$EMAIL" -f "$KEY_PATH" -N ""
fi

eval "$(ssh-agent -s)"

ssh-add -l | grep -q "$KEY_PATH"
if [ $? -ne 0 ]; then
  ssh-add "$KEY_PATH"
fi
