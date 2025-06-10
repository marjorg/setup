#!/bin/bash

set -e
set -o pipefail

source shared.sh
source utilities.sh

if [[ "$IS_MAC" == true ]]; then
  TASKS_DIR="$DOTFILES_DIR/tasks/mac"
elif [[ "$IS_UBUNTU" == true ]]; then
  TASKS_DIR="$DOTFILES_DIR/tasks/ubuntu"
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
