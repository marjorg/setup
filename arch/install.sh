#!/bin/bash

sudo -v

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils.sh"

PACMAN_PACKAGES=()
YAY_PACKAGES=()
MISE_PACKAGES=()
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

PACMAN_PACKAGES=($(printf "%s\n" "${PACMAN_PACKAGES[@]}" | sort -u))
PACMAN_PACKAGES_NOT_INSTALLED=()

for pkg in "${PACMAN_PACKAGES[@]}"; do
  if ! pacman -Q "$pkg" &>/dev/null; then
    PACMAN_PACKAGES_NOT_INSTALLED+=("$pkg")
  else
    debug "Package '$pkg' is already installed. Skipping."
  fi
done

if [ "${#PACMAN_PACKAGES_NOT_INSTALLED[@]}" -gt 0 ]; then
  log "Installing Pacman packages: ${PACMAN_PACKAGES_NOT_INSTALLED[*]}"
  execute sudo pacman -Sy --noconfirm --needed "${PACMAN_PACKAGES_NOT_INSTALLED[@]}" >>"$LOG_FILE" 2>&1 || log "Pacman installation failed."
else
  log "No Pacman packages to install."
fi

YAY_PACKAGES=($(printf "%s\n" "${YAY_PACKAGES[@]}" | sort -u))
YAY_PACKAGES_NOT_INSTALLED=()

for pkg in "${YAY_PACKAGES[@]}"; do
  if ! yay -Q "$pkg" &>/dev/null; then
    YAY_PACKAGES_NOT_INSTALLED+=("$pkg")
  else
    debug "Yay package '$pkg' is already installed. Skipping."
  fi
done

if [ "${#YAY_PACKAGES_NOT_INSTALLED[@]}" -gt 0 ]; then
  log "Installing Yay packages: ${YAY_PACKAGES_NOT_INSTALLED[*]}"
  execute yay -Sy --noconfirm --needed "${YAY_PACKAGES_NOT_INSTALLED[@]}" >>"$LOG_FILE" 2>&1 || log "Yay installation failed."
else
  log "No Yay packages to install."
fi

MISE_PACKAGES=($(printf "%s\n" "${MISE_PACKAGES[@]}" | sort -u))
# TODO: Add already installed filter?

if [ "${#MISE_PACKAGES[@]}" -gt 0 ]; then
  log "Installing Mise packages: ${MISE_PACKAGES[*]}"
  execute mise use --global "${MISE_PACKAGES[@]}" >>"$LOG_FILE" 2>&1 || log "Mise installation failed."
else
  log "No Mise packages to install."
fi

# TODO: Might have to source shell here to make go install work after mise install

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
