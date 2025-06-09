#!/bin/bash

if [[ -d "$DOTFILES_DIR" ]]; then
  for file in "$DOTFILES_DIR/scripts/"*.sh; do
    if [ -f "$file" ]; then
      source "$file"
    fi
  done
fi
