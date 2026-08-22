#!/bin/bash

sudo -v

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/scripts/utils.sh" "$@"

"$SCRIPT_DIR/scripts/generate-gpg-key.sh" "$@"
"$SCRIPT_DIR/scripts/generate-ssh-key.sh" "$@"
"$SCRIPT_DIR/scripts/write-ssh-config.sh" "$@"
"$SCRIPT_DIR/scripts/set-symlinks.sh" "$@"
"$SCRIPT_DIR/scripts/write-git-config.sh" "$@"

BACKGROUNDS="$DOTFILES_DIR/backgrounds"
THEME_NAME="$(cat "$HOME/.local/state/omarchy/current/theme.name" 2>/dev/null)"
OMARCHY_BACKGROUNDS="$HOME/.config/omarchy/backgrounds/$THEME_NAME"

if [[ -z "$THEME_NAME" ]]; then
  log "Warning: No current Omarchy theme, skipping background sync"
elif [[ -d "$BACKGROUNDS" ]] && [[ -n "$(ls -A "$BACKGROUNDS" 2>/dev/null)" ]]; then
  mkdir -p "$OMARCHY_BACKGROUNDS"
  rsync -a --delete "$BACKGROUNDS/" "$OMARCHY_BACKGROUNDS/"
  omarchy-theme-bg-cache 2>/dev/null || true
else
  log "Warning: Backgrounds directory empty or missing, skipping sync"
fi

CHROMIUM_EXTENSIONS="/etc/chromium/policies/managed/extensions.json"
if [ ! -f "$CHROMIUM_EXTENSIONS" ]; then
  cat >"$CHROMIUM_EXTENSIONS" <<EOF
{
  "ExtensionInstallForcelist": [
    // uBlock Lite
    "ddkjiahejlhfcafbddmgiahcphecmpfh",
    // 1password
    "aeblfdkhhhdcdjpifhhbdiojplfjncoa",
    // React DevTools
    "fmkadmapgofadopljbjfkapdkoienihi"
  ]
}
EOF
fi

CHROMIUM_SETTINGS="/etc/chromium/policies/managed/policy.json"
if [ ! -f "$CHROMIUM_SETTINGS" ]; then
  cat >"$CHROMIUM_SETTINGS" <<EOF
{
  "PasswordManagerEnabled": false
}
EOF
fi

log "Files setup."
