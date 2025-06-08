#!/bin/bash

set -e
set -o pipefail

DOTFILES_DIR="$HOME/dotfiles"
PACKAGES_DIR="$DOTFILES_DIR/packages"

# Avoid tools such as NVM from modifying these files
rm -f "$HOME/.bashrc" "$HOME/.profile"

DRY=false
DEBUG=false
WORK=false

while [[ $# > 0 ]]; do
  if [[ $1 == "--dry" ]]; then
    DRY=true
  elif [[ $1 == "--debug" ]]; then
    DEBUG=true
  elif [[ $1 == "--work" ]]; then
    WORK=true
  fi

  shift
done

IS_MAC=$(uname -s | grep -q Darwin && echo true || echo false)
IS_LINUX=$(uname -s | grep -q Linux && echo true || echo false)

if [[ "$IS_MAC" == "false" && "$IS_LINUX" == "false" ]]; then
  echo "🚨 Unsupported OS" >&2
  exit 1
fi

if [[ -d "$DOTFILES_DIR" ]]; then
  for file in "$DOTFILES_DIR/scripts/"*.sh; do
    if [ -f "$file" ]; then
      source "$file"
    fi
  done
fi
