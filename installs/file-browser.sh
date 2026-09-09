#!/bin/bash

PACMAN_PACKAGES+=(
  nautilus
)

# Nautilus keeps its preferences in dconf, not a config file, so they are
# applied declaratively here instead of symlinked.
NAUTILUS_SETTINGS=(
  "org.gnome.nautilus.preferences default-folder-viewer 'list-view'"
  "org.gnome.nautilus.list-view default-zoom-level 'small'"
  "org.gtk.gtk4.Settings.FileChooser show-hidden true"
  "org.gtk.gtk4.Settings.FileChooser sort-directories-first true"
)

post_install() {
  if ! command -v gsettings >/dev/null 2>&1; then
    log "gsettings not found, skipping Nautilus settings"
    return
  fi

  for setting in "${NAUTILUS_SETTINGS[@]}"; do
    read -r schema key value <<<"$setting"

    if [[ "$(gsettings get "$schema" "$key" 2>/dev/null)" == "$value" ]]; then
      debug "$schema $key is already $value. Skipping."
      continue
    fi

    log "Setting $schema $key to $value"
    gsettings set "$schema" "$key" "$value" || log "Failed to set $schema $key"
  done
}
