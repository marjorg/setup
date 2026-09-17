#!/bin/bash

sudo -v

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/scripts/utils.sh" "$@"

PACMAN_PACKAGES=()
YAY_PACKAGES=()
MISE_PACKAGES=()
BUN_PACKAGES=()
VSCODE_EXTENSIONS=()
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

pacman_installed() {
  pacman -Q "$1" &>/dev/null || return 1
  debug "Package '$1' is already installed. Skipping."
}

yay_installed() {
  yay -Q "$1" &>/dev/null || return 1
  debug "Yay package '$1' is already installed. Skipping."
}

mise_installed() {
  local tool="${1%%@*}" version="${1#*@}"

  mise ls --json | jq -e --arg tool "$tool" --arg version "$version" '
    .[$tool] // [] |
    map(select(.requested_version == $version and .active == true)) |
    length > 0
  ' &>/dev/null || return 1

  debug "Package '$1' is already installed and active. Skipping."
}

go_installed() {
  local binary_name="${1##*/}"
  binary_name="${binary_name%%@*}"

  if ! command -v go >/dev/null 2>&1; then
    eval "$(mise activate bash)"
  fi

  local go_bin="${GOBIN:-$(go env GOPATH)/bin}"

  [ -f "$go_bin/$binary_name" ] || return 1
  debug "Go tool '$binary_name' is already installed. Skipping."
}

bun_installed() {
  local pkg_name

  if [[ "$1" == @*/* ]]; then
    # Scoped package: strip version after the second @
    pkg_name="${1%@*}"
    # If no version was specified, pkg_name equals pkg, which is fine
    [[ "$pkg_name" == *"/"* ]] || pkg_name="$1"
  else
    pkg_name="${1%%@*}"
  fi

  if ! command -v bun >/dev/null 2>&1; then
    eval "$(mise activate bash)"
  fi

  bun pm ls -g 2>/dev/null | grep -q "$pkg_name" || return 1
  debug "Bun package '$pkg_name' is already installed. Skipping."
}

PACMAN_PACKAGES=($(printf "%s\n" "${PACMAN_PACKAGES[@]}" | sort -u))
PACMAN_PACKAGES_NOT_INSTALLED=()
filter_not_installed PACMAN_PACKAGES PACMAN_PACKAGES_NOT_INSTALLED pacman_installed

if [ "${#PACMAN_PACKAGES_NOT_INSTALLED[@]}" -gt 0 ]; then
  log "Installing Pacman packages: ${PACMAN_PACKAGES_NOT_INSTALLED[*]}"
  execute sudo pacman -Sy --noconfirm --needed "${PACMAN_PACKAGES_NOT_INSTALLED[@]}" >>"$LOG_FILE" 2>&1 || log "Pacman installation failed."
else
  log "No Pacman packages to install."
fi

YAY_PACKAGES=($(printf "%s\n" "${YAY_PACKAGES[@]}" | sort -u))
YAY_PACKAGES_NOT_INSTALLED=()
filter_not_installed YAY_PACKAGES YAY_PACKAGES_NOT_INSTALLED yay_installed

if [ "${#YAY_PACKAGES_NOT_INSTALLED[@]}" -gt 0 ]; then
  log "Installing Yay packages: ${YAY_PACKAGES_NOT_INSTALLED[*]}"
  execute yay -Sy --noconfirm --needed "${YAY_PACKAGES_NOT_INSTALLED[@]}" >>"$LOG_FILE" 2>&1 || log "Yay installation failed."
else
  log "No Yay packages to install."
fi

MISE_PACKAGES=($(printf "%s\n" "${MISE_PACKAGES[@]}" | sort -u))
MISE_PACKAGES_NOT_INSTALLED=()
filter_not_installed MISE_PACKAGES MISE_PACKAGES_NOT_INSTALLED mise_installed

if [ "${#MISE_PACKAGES_NOT_INSTALLED[@]}" -gt 0 ]; then
  log "Installing Mise packages: ${MISE_PACKAGES_NOT_INSTALLED[*]}"
  execute mise use --global "${MISE_PACKAGES_NOT_INSTALLED[@]}" >>"$LOG_FILE" 2>&1 || log "Mise installation failed."
else
  log "No Mise packages to install."
fi

GO_PACKAGES=($(printf "%s\n" "${GO_PACKAGES[@]}" | sort -u))
GO_PACKAGES_NOT_INSTALLED=()
filter_not_installed GO_PACKAGES GO_PACKAGES_NOT_INSTALLED go_installed

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
filter_not_installed BUN_PACKAGES BUN_PACKAGES_NOT_INSTALLED bun_installed

if [ "${#BUN_PACKAGES_NOT_INSTALLED[@]}" -gt 0 ]; then
  log "Installing Bun packages: ${BUN_PACKAGES_NOT_INSTALLED[*]}"
  execute bun install --global "${BUN_PACKAGES_NOT_INSTALLED[@]}" >>"$LOG_FILE" 2>&1 || log "Bun installation failed."
else
  log "No Bun packages to install."
fi

vscode_ext_installed() {
  echo "$INSTALLED_EXTENSIONS" | grep -qi "^${1}$" || return 1
  debug "VS Code extension '$1' is already installed. Skipping."
}

if command -v code &>/dev/null && [ "${#VSCODE_EXTENSIONS[@]}" -gt 0 ]; then
  VSCODE_EXTENSIONS=($(printf "%s\n" "${VSCODE_EXTENSIONS[@]}" | sort -u))
  INSTALLED_EXTENSIONS=$(code --list-extensions 2>/dev/null)
  VSCODE_EXTENSIONS_NOT_INSTALLED=()
  filter_not_installed VSCODE_EXTENSIONS VSCODE_EXTENSIONS_NOT_INSTALLED vscode_ext_installed

  if [ "${#VSCODE_EXTENSIONS_NOT_INSTALLED[@]}" -gt 0 ]; then
    log "Installing VS Code extensions: ${VSCODE_EXTENSIONS_NOT_INSTALLED[*]}"
    for ext in "${VSCODE_EXTENSIONS_NOT_INSTALLED[@]}"; do
      execute code --install-extension "$ext" >>"$LOG_FILE" 2>&1 || log "Failed to install VS Code extension: $ext"
    done
  else
    log "No VS Code extensions to install."
  fi
else
  debug "VS Code not found or no extensions to install. Skipping."
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
