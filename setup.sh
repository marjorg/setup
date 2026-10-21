#!/bin/bash

set -e
set -o pipefail

IS_LINUX=$(uname -s | grep -q Linux && echo true || echo false)
OS_ID=""

if [[ "$IS_LINUX" == true ]]; then
  OS_ID=$(grep '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"')
fi

case "$OS_ID" in
  omarchy|ubuntu) ;;
  *)
    echo "🚨 Unsupported OS ($OS_ID)" >&2
    exit 1
    ;;
esac

DOTFILES_DIR="$HOME/dotfiles"

if [[ ! -d "$DOTFILES_DIR" ]]; then
  if ! [ -x "$(command -v git)" ]; then
    if [[ "$OS_ID" == "omarchy" ]]; then
      sudo pacman -S --needed git
    else
      sudo apt-get update
      sudo apt-get install -y git
    fi

    echo "✅ Installed Git"
  fi

  git clone --quiet https://github.com/marjorg/setup.git "$DOTFILES_DIR"
  echo "✅ Cloned repository to $DOTFILES_DIR"
else
  echo "⚠️ Repository already exist in $DOTFILES_DIR"
fi
