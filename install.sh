#!/bin/bash

sudo -v

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/scripts/utils.sh"

PACMAN_PACKAGES=()
YAY_PACKAGES=()
MISE_PACKAGES=()
BUN_PACKAGES=()
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
  if [ "$UPDATE_MODE" = true ]; then
    PACMAN_PACKAGES_NOT_INSTALLED+=("$pkg")
  elif ! pacman -Q "$pkg" &>/dev/null; then
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
  if [ "$UPDATE_MODE" = true ]; then
    YAY_PACKAGES_NOT_INSTALLED+=("$pkg")
  elif ! yay -Q "$pkg" &>/dev/null; then
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
MISE_PACKAGES_NOT_INSTALLED=()

for pkg in "${MISE_PACKAGES[@]}"; do
  tool="${pkg%%@*}"
  version="${pkg#*@}"

  if [ "$UPDATE_MODE" = true ]; then
    MISE_PACKAGES_NOT_INSTALLED+=("$pkg")
  elif mise ls --json | jq -e --arg tool "$tool" --arg version "$version" '
    .[$tool] // [] |
    map(select(.requested_version == $version and .active == true)) |
    length > 0
  ' &>/dev/null; then
    debug "Package '$pkg' is already installed and active. Skipping."
  else
    MISE_PACKAGES_NOT_INSTALLED+=("$pkg")
  fi
done

if [ "${#MISE_PACKAGES_NOT_INSTALLED[@]}" -gt 0 ]; then
  log "Installing Mise packages: ${MISE_PACKAGES_NOT_INSTALLED[*]}"
  execute mise use --global "${MISE_PACKAGES_NOT_INSTALLED[@]}" >>"$LOG_FILE" 2>&1 || log "Mise installation failed."
else
  log "No Mise packages to install."
fi

GO_PACKAGES=($(printf "%s\n" "${GO_PACKAGES[@]}" | sort -u))
GO_PACKAGES_NOT_INSTALLED=()

for pkg in "${GO_PACKAGES[@]}"; do
  # Extract the binary name from the package path. Ex: golang.org/x/tools/gopls -> gopls
  binary_name="${pkg##*/}"
  binary_name="${binary_name%%@*}"

  if ! command -v go >/dev/null 2>&1; then
    eval "$(mise activate bash)"
  fi

  # Check if the binary exists in GOPATH/bin or GOBIN
  go_bin="${GOBIN:-$(go env GOPATH)/bin}"

  if [ "$UPDATE_MODE" = true ]; then
    GO_PACKAGES_NOT_INSTALLED+=("$pkg")
  elif [ -f "$go_bin/$binary_name" ]; then
    debug "Go tool '$binary_name' is already installed. Skipping."
  else
    GO_PACKAGES_NOT_INSTALLED+=("$pkg")
  fi
done

if [ "${#GO_PACKAGES_NOT_INSTALLED[@]}" -gt 0 ]; then
  log "Installing Go packages: ${GO_PACKAGES_NOT_INSTALLED[*]}"
  for pkg in "${GO_PACKAGES_NOT_INSTALLED[@]}"; do
    execute go install "$pkg" >>"$LOG_FILE" 2>&1 || log "Failed to install $pkg"
  done
else
  log "No Go packages to install."
fi

BUN_PACKAGES=($(printf "%s\n" "${BUN_PACKAGES[@]}" | sort -u))
BUN_PACKAGES_NOT_INSTALLED=()

for pkg in "${BUN_PACKAGES[@]}"; do
  if [[ "$pkg" == @*/* ]]; then
    # Scoped package: strip version after the second @
    pkg_name="${pkg%@*}"
    # If no version was specified, pkg_name equals pkg, which is fine
    [[ "$pkg_name" == *"/"* ]] || pkg_name="$pkg"
  else
    pkg_name="${pkg%%@*}"
  fi

  if ! command -v bun >/dev/null 2>&1; then
    eval "$(mise activate bash)"
  fi

  if [ "$UPDATE_MODE" = true ]; then
    BUN_PACKAGES_NOT_INSTALLED+=("$pkg")
  elif bun pm ls -g 2>/dev/null | grep -q "$pkg_name"; then
    debug "Bun package '$pkg_name' is already installed. Skipping."
  else
    BUN_PACKAGES_NOT_INSTALLED+=("$pkg")
  fi
done

if [ "${#BUN_PACKAGES_NOT_INSTALLED[@]}" -gt 0 ]; then
  log "Installing Bun packages: ${BUN_PACKAGES_NOT_INSTALLED[*]}"
  execute bun install --global "${BUN_PACKAGES_NOT_INSTALLED[@]}" >>"$LOG_FILE" 2>&1 || log "Bun installation failed."
else
  log "No Bun packages to install."
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
