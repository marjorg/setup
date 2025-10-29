#!/bin/bash

set -euo pipefail

DOTFILES_DIR="$HOME/dotfiles"

LOG_FILE="$DOTFILES_DIR/install.log"
: > "$LOG_FILE"

trap 'echo "Error at line $LINENO. Check $LOG_FILE for details." >&2' ERR

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

log() {
  if $DRY; then
    echo "[DRY RUN] $@"
  else
    echo "$@"
  fi
}

debug() {
  if $DEBUG; then
    echo "[DEBUG] $@"
  fi
}

execute() {
  if [[ "$DRY" == true ]]; then
    log "$@"

  else
    if [[ "$1" == "eval" ]]; then
      eval "${@:2}"
    elif [[ "$1" == "capture" ]]; then
      "${@:2}"
    else
      "$@"
    fi
  fi
}

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
