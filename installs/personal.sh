#!/bin/bash

post_install() {
  if [[ "$WORK" == true ]]; then
    return
  fi

  DIRECTORY="$HOME/notes"

  if [[ ! -d "$DIRECTORY" ]]; then
    git clone --quiet git@github.com:marjorg/notes.git "$DIRECTORY"
  else
    git -C "$DIRECTORY" pull --quiet
  fi
}
