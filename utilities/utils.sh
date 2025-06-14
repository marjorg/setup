#!/bin/bash

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
