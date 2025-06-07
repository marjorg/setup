#!/bin/bash

source shared.sh

if [[ "$IS_MAC" == true ]]; then
  execute brew update
  execute brew upgrade
  # MAS temporarily disabled due to https://github.com/mas-cli/mas/issues/724
  # execute mas upgrade
elif [[ "$IS_LINUX" == true ]]; then
  execute sudo apt-get update
  execute sudo apt-get upgrade -y
fi

for pkg in "$PACKAGES_DIR"/*; do
  if [[ -f "$pkg" ]]; then
    source "$pkg"
    name=$(basename "${pkg%.sh}")

    if declare -F update > /dev/null; then
      debug "Updating $name"
      update
      unset -f update
      log "✅ Updated $name"
    else
      debug "Skipping $name – no update function"
    fi
  fi
done

if [[ "$IS_MAC" == true ]]; then
  execute brew cleanup
elif [[ "$IS_LINUX" == true ]]; then
  execute sudo apt autoremove
  execute sudo apt autoclean
fi

execute rm -f "$HOME/.zprofile"
