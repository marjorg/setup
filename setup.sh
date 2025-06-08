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
SCRIPT_NAME=$(basename "$0")

if [[ "$0" != "$DOTFILES_DIR/$SCRIPT_NAME" && ! -d "$DOTFILES_DIR" ]]; then
  if ! [ -x "$(command -v git)" ]; then
    if [[ "$IS_MAC" == true ]]; then
      brew install git
    elif [[ "$IS_LINUX" == true ]]; then
      sudo apt-get install git -y
    fi

    echo "✅ Installed Git"
  fi

  git clone --quiet https://github.com/marjorg/setup.git $DOTFILES_DIR
  echo "✅ Cloned repository"
else
  if [ -z "$(git -C $DOTFILES_DIR status --porcelain)" ]; then
    git -C $DOTFILES_DIR pull --quiet
    echo "✅ Updated repository"
  else
    echo "⚠️ Local changes detected in dotfiles repository, skipping pull"
  fi
fi
