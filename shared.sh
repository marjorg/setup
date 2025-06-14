#!/bin/bash

set -e
set -o pipefail

DOTFILES_DIR="$HOME/dotfiles"

# Avoid tools such as NVM from modifying these files
rm -f "$HOME/.bashrc" "$HOME/.profile"

DRY=false
DEBUG=false
WORK=false
DEPS_ONLY=false
EMAIL="git@mjorg.dev"

while [[ $# > 0 ]]; do
  if [[ $1 == "--dry" ]]; then
    DRY=true
  elif [[ $1 == "--debug" ]]; then
    DEBUG=true
  elif [[ $1 == "--work" ]]; then
    WORK=true
  elif [[ $1 == "--deps-only" ]]; then
    DEPS_ONLY=true
  elif [[ $1 == "--email" ]]; then
    shift
    EMAIL="$1"
  fi

  shift
done

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

if [[ "$IS_MAC" == "false" && "$IS_LINUX" == "false" ]]; then
  echo "🚨 Unsupported OS" >&2
  exit 1
fi
