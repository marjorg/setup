#!/bin/bash

set -euo pipefail

DOTFILES_DIR="$HOME/dotfiles"

LOG_FILE="$DOTFILES_DIR/install.log"
: > "$LOG_FILE"

trap 'echo "Error at line $LINENO. Check $LOG_FILE for details." >&2' ERR

DRY=false
DEBUG=false
WORK=false
EMAIL="git@mjorg.dev"
NAME="Marius Jørgensen"
UPDATE_MODE=false

while [[ $# > 0 ]]; do
  if [[ $1 == "--dry" ]]; then
    DRY=true
  elif [[ $1 == "--debug" ]]; then
    DEBUG=true
  elif [[ $1 == "--work" ]]; then
    WORK=true
  elif [[ $1 == "--name" ]]; then
    shift
    NAME="$1"
  elif [[ $1 == "--email" ]]; then
    shift
    EMAIL="$1"
  elif [[ $1 == "--update" ]]; then
    UPDATE_MODE=true
  fi

  shift
done

log() {
  local msg

  if $DRY; then
    msg="[DRY RUN] $@"
  else
    msg="$@"
  fi

  echo "$msg"
  echo "$msg" >> "$LOG_FILE"
}

debug() {
  if $DEBUG; then
    echo "[DEBUG] $@"
  fi
}

execute() {
  if $DRY; then
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
IS_ARCH=false

if [[ "$IS_LINUX" == true ]]; then
  OS_ID=$(grep '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"')

  if [[ "$OS_ID" == "arch" ]]; then
    IS_ARCH=true
  fi
fi
