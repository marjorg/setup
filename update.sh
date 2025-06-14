#!/bin/bash

source shared.sh
source utilities.sh

if [[ "$IS_MAC" == true ]]; then
  execute brew update
  execute brew upgrade
  # MAS temporarily disabled due to https://github.com/mas-cli/mas/issues/724
  # execute mas upgrade
elif [[ "$IS_UBUNTU" == true ]]; then
  execute sudo apt-get update
  execute sudo apt-get upgrade -y
elif [[ "$IS_ARCH" == true ]]; then
  execute sudo pacman -Syu --noconfirm
fi

for task in "$TASKS_DIR"/*.sh; do
  if [[ -f "$task" ]]; then
    source "$task"
    TASK_NAME=$(basename "${task%.sh}")

    if declare -F update > /dev/null; then
      debug "Running $TASK_NAME update..."
      update
      unset -f update
    fi
  fi
done

if [[ "$IS_MAC" == true ]]; then
  execute brew cleanup
elif [[ "$IS_UBUNTU" == true ]]; then
  execute sudo apt-get autoremove
  execute sudo apt-get autoclean
elif [[ "$IS_ARCH" == true ]]; then
  execute sudo pacman -Sc --noconfirm
fi
