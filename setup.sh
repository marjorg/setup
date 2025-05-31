#!/bin/bash

set -e
set -o pipefail

DOTFILES_DIR="$HOME/dotfiles"
IS_MAC=$(uname -s | grep -q Darwin && echo true || echo false)
IS_LINUX=$(uname -s | grep -q Linux && echo true || echo false)

if ! [[ -d "$DOTFILES_DIR" ]]; then
  git clone --quiet https://github.com/marjorg/setup.git $DOTFILES_DIR
  echo "✅ Cloned repository"
else
  for file in "$DOTFILES_DIR/scripts/"*; do
    if [ -f "$file" ]; then
      source "$file"
    fi
  done

  if [ -z "$(git -C $DOTFILES_DIR status --porcelain)" ]; then
    execute git -C $DOTFILES_DIR pull --quiet
    log "✅ Updated repository"
  else
    debug "⚠️ Local changes detected in dotfiles repository, skipping pull"
  fi
fi
