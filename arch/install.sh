#!/bin/bash

sudo -v

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils.sh"

PACMAN_PACKAGES=()
YAY_PACKAGES=()
PRE_INSTALL_SCRIPTS=()
POST_INSTALL_SCRIPTS=()

for script in "$SCRIPT_DIR"/installs/*.sh; do
  debug "Sourcing script: $script"
  source "$script"

  if declare -F pre_install > /dev/null; then
    PRE_INSTALL_SCRIPTS+=("$script")
  fi

  if declare -F post_install > /dev/null; then
    POST_INSTALL_SCRIPTS+=("$script")
  fi

  # Avoid conflict in the next iteration
  unset -f pre_install 2>/dev/null || true
  unset -f post_install 2>/dev/null || true
done

if [ "${#PRE_INSTALL_SCRIPTS[@]}" -gt 0 ]; then
  log "Running pre-install scripts..."

  for script in "${PRE_INSTALL_SCRIPTS[@]}"; do
    log "Executing pre_install from $script"
    source "$script"
    execute pre_install >>"$LOG_FILE" 2>&1 || log "pre_install in $script failed."
    unset -f pre_install 2>/dev/null || true
  done
else
  debug "No pre-install scripts to run."
fi

# Deduplicate
PACMAN_PACKAGES=($(printf "%s\n" "${PACMAN_PACKAGES[@]}" | sort -u))
YAY_PACKAGES=($(printf "%s\n" "${YAY_PACKAGES[@]}" | sort -u))

if [ "${#PACMAN_PACKAGES[@]}" -gt 0 ]; then
  log "Installing Pacman packages: ${PACMAN_PACKAGES[*]}"
  execute sudo pacman -Sy --noconfirm --needed "${PACMAN_PACKAGES[@]}" >>"$LOG_FILE" 2>&1 || log "Pacman installation failed."
else
  debug "No Pacman packages to install."
fi

if [ "${#YAY_PACKAGES[@]}" -gt 0 ]; then
  if ! command -v yay &>/dev/null; then
    log "Yay is not installed. Skipping AUR package installation."
  else
    log "Installing Yay packages: ${YAY_PACKAGES[*]}"
    execute yay -Sy --noconfirm --needed "${YAY_PACKAGES[@]}" >>"$LOG_FILE" 2>&1 || log "Yay installation failed."
  fi
else
  debug "No Yay packages to install."
fi

if [ "${#POST_INSTALL_SCRIPTS[@]}" -gt 0 ]; then
  log "Running post-install scripts..."

  for script in "${POST_INSTALL_SCRIPTS[@]}"; do
    log "Executing post_install from $script"
    source "$script"
    execute post_install >>"$LOG_FILE" 2>&1 || log "post_install in $script failed."
    unset -f post_install 2>/dev/null || true
  done
else
  debug "No post-install scripts to run."
fi

log "Installation completed."
