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
  if $DRY; then
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
  local type_name="$1"
  local packages_file="$2"
  local jq_filter="$3"
  local id_field="$4"
  local install_function="$5"

  log "⌛ Installing ${type_name}..."

  local packages=$(jq -c "to_entries[] | .value[] | select($jq_filter)" "$packages_file")

  if [[ -z "$packages" ]]; then
    debug "⚠️ No applications with ${type_name}"
    return
  fi

  echo "$packages" | while read -r package; do
    if [[ -n "$package" ]]; then
      local id=$(echo "$package" | jq -r ".$id_field")
      local name=$(echo "$package" | jq -r '.name')

      if [[ -n "$id" ]]; then
        "$install_function" "$id" "$name"
      fi
    fi
  done
}
