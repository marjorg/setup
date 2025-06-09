#!/bin/bash

set -e
set -o pipefail

IS_MAC=$(uname -s | grep -q Darwin && echo true || echo false)
IS_LINUX=$(uname -s | grep -q Linux && echo true || echo false)

if [[ "$IS_MAC" == "false" && "$IS_LINUX" == "false" ]]; then
  echo "🚨 Unsupported OS" >&2
  exit 1
fi

DOTFILES_DIR="$HOME/dotfiles"

if [[ ! -d "$DOTFILES_DIR" ]]; then
  if ! [ -x "$(command -v git)" ]; then
    if [[ "$IS_MAC" == true ]]; then
      brew install git
    elif [[ "$IS_LINUX" == true ]]; then
      sudo apt-get install git -y
    fi

    echo "✅ Installed Git"
  fi

  git clone --quiet https://github.com/marjorg/setup.git $DOTFILES_DIR
  echo "✅ Cloned repository to $DOTFILES_DIR"
else
  echo "⚠️ Repository already exist in $DOTFILES_DIR"
fi
