#!/bin/bash

set -e
set -o pipefail

IS_MAC=$(uname -s | grep -q Darwin && echo true || echo false)
IS_LINUX=$(uname -s | grep -q Linux && echo true || echo false)
IS_UBUNTU=false
IS_ARCH=false

if [[ "$IS_LINUX" == true ]]; then
  OS_ID=$(grep '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"')

  if [[ "$OS_ID" == "ubuntu" ]]; then
    IS_UBUNTU=true
  elif [[ "$OS_ID" == "arch" ]]; then
    IS_ARCH=true
  fi
fi

if [[ "$IS_MAC" == "false" && "$IS_UBUNTU" == "false" && "$IS_ARCH" == "false" ]]; then
  echo "🚨 Unsupported OS" >&2
  exit 1
fi

DOTFILES_DIR="$HOME/dotfiles"

if [[ ! -d "$DOTFILES_DIR" ]]; then
  if ! [ -x "$(command -v git)" ]; then
    if [[ "$IS_MAC" == true ]]; then
      brew install git
    elif [[ "$IS_UBUNTU" == true ]]; then
      sudo apt-get install git -y
    elif [[ "$IS_ARCH" == true ]]; then
      sudo pacman -S --needed git
    fi

    echo "✅ Installed Git"
  fi

  git clone --quiet https://github.com/marjorg/setup.git $DOTFILES_DIR
  echo "✅ Cloned repository to $DOTFILES_DIR"
else
  echo "⚠️ Repository already exist in $DOTFILES_DIR"
fi
