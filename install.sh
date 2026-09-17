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

# Sources each script in $2 (array name) again and calls the $1 hook
# function ("pre_install" or "post_install") that it defines.
run_lifecycle_scripts() {
  local hook=$1 scripts_array_name=$2
  local -n _scripts=$scripts_array_name
  local label="${hook/_/-}"

  if [ "${#_scripts[@]}" -eq 0 ]; then
    debug "No $label scripts to run."
    return
  fi

  log "Running $label scripts..."

  local script
  for script in "${_scripts[@]}"; do
    log "Executing $hook from $script"
    source "$script"
    execute "$hook" >>"$LOG_FILE" 2>&1 || log "$hook in $script failed."
    unset -f "$hook" 2>/dev/null || true
  done
}

run_lifecycle_scripts pre_install PRE_INSTALL_SCRIPTS

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

# Sorts and dedupes $1 (package array name), filters it down to items that
# fail $3 (predicate), then installs the remainder in one call to "$4...".
install_bulk() {
  local pkg_array_name=$1 label=$2 predicate=$3
  shift 3

  local -n _pkgs=$pkg_array_name
  _pkgs=($(printf "%s\n" "${_pkgs[@]}" | sort -u))

  local not_installed=()
  filter_not_installed "$pkg_array_name" not_installed "$predicate"

  if [ "${#not_installed[@]}" -gt 0 ]; then
    log "Installing $label: ${not_installed[*]}"
    execute "$@" "${not_installed[@]}" >>"$LOG_FILE" 2>&1 || log "$label installation failed."
  else
    log "No $label to install."
  fi
}

# Same as install_bulk, but invokes "$4..." once per item instead of once
# for the whole batch.
install_each() {
  local pkg_array_name=$1 label=$2 predicate=$3
  shift 3

  local -n _pkgs=$pkg_array_name
  _pkgs=($(printf "%s\n" "${_pkgs[@]}" | sort -u))

  local not_installed=()
  filter_not_installed "$pkg_array_name" not_installed "$predicate"

  if [ "${#not_installed[@]}" -gt 0 ]; then
    log "Installing $label: ${not_installed[*]}"
    local item
    for item in "${not_installed[@]}"; do
      execute "$@" "$item" >>"$LOG_FILE" 2>&1 || log "Failed to install $item"
    done
  else
    log "No $label to install."
  fi
}

install_bulk PACMAN_PACKAGES "Pacman packages" pacman_installed sudo pacman -Sy --noconfirm --needed
install_bulk YAY_PACKAGES "Yay packages" yay_installed yay -Sy --noconfirm --needed
install_bulk MISE_PACKAGES "Mise packages" mise_installed mise use --global
install_each GO_PACKAGES "Go packages" go_installed go install
install_bulk BUN_PACKAGES "Bun packages" bun_installed bun install --global

vscode_ext_installed() {
  echo "$INSTALLED_EXTENSIONS" | grep -qi "^${1}$" || return 1
  debug "VS Code extension '$1' is already installed. Skipping."
}

if command -v code &>/dev/null && [ "${#VSCODE_EXTENSIONS[@]}" -gt 0 ]; then
  INSTALLED_EXTENSIONS=$(code --list-extensions 2>/dev/null)
  install_each VSCODE_EXTENSIONS "VS Code extensions" vscode_ext_installed code --install-extension
else
  debug "VS Code not found or no extensions to install. Skipping."
fi

run_lifecycle_scripts post_install POST_INSTALL_SCRIPTS

log "Installation completed."
