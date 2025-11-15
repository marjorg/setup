#!/bin/bash

# TODO: Should be moved to files script when added

post_install() {
  if $WORK; then
    return
  fi

  DIRECTORY="$HOME/notes"

  if [[ ! -d "$DIRECTORY" ]]; then
    git clone --quiet git@github.com:marjorg/notes.git "$DIRECTORY"
  else
    git -C "$DIRECTORY" pull --quiet
  fi
}
