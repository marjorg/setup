#!/bin/bash

set -e
set -o pipefail

DRY=false
DEBUG=false

DOTFILES_DIR="$HOME/dotfiles"
IS_MAC=$(uname -s | grep -q Darwin && echo true || echo false)

while [[ $# > 0 ]]; do
  if [[ $1 == "--dry" ]]; then
    DRY=true
  elif [[ $1 == "--debug" ]]; then
    DEBUG=true
  fi

  shift
done

for file in "$DOTFILES_DIR/scripts/"*; do
  if [ -f "$file" ]; then
    source "$file"
  fi
done

if $IS_MAC; then
  update_mac
else
  log "🚨 Unsupported OS"
  exit 1
fi
