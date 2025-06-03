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
  if [[ "$DRY" == "true" ]]; then
    log "$@"

    if [[ "$*" == *"get_op_password"* ]]; then
      echo "dry-run-password"
    fi
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

install_package_type() {
  local packages_file="$1"
  local jq_filter="$2"
  local id_field="$3"
  local install_function="$4"

  local packages=$(jq -c "to_entries[] | .value[] | select($jq_filter)" "$packages_file")

  if [[ -z "$packages" ]]; then
    debug "⚠️ No applications with ${jq_filter}"
    return
  fi

  echo "$packages" | while read -r package; do
    if [[ -n "$package" ]]; then
      local id=$(echo "$package" | jq -r ".$id_field")

      if [[ -n "$id" ]]; then
        "$install_function" "$id"
      fi
    fi
  done
}
