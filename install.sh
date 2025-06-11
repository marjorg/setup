#!/bin/bash

set -e
set -o pipefail

source shared.sh
source utilities.sh

if [[ "$IS_MAC" == true ]]; then
  TASKS_DIR="$DOTFILES_DIR/tasks/mac"
elif [[ "$IS_UBUNTU" == true ]]; then
  UBUNTU_VERSION=$(lsb_release -rs)

  case "$UBUNTU_VERSION" in
    22.04)
      TASKS_DIR="$DOTFILES_DIR/tasks/ubuntu/22.04"
      ;;
    *)
      echo "🚨 Unsupported Ubuntu version: $UBUNTU_VERSION" >&2
      exit 1
      ;;
  esac
else
  echo "🚨 Unsupported OS/Distribution" >&2
  exit 1
fi

for task in "$TASKS_DIR"/*.sh; do
  if [[ -f "$task" ]]; then
    source "$task"
    TASK_NAME=$(basename "${task%.sh}")

    if declare -F install > /dev/null; then
      debug "Running $TASK_NAME install..."
      install
      unset -f install
    fi
  fi
done
