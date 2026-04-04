#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/scripts/utils.sh"

"$SCRIPT_DIR/scripts/generate-gpg-key.sh" "$EMAIL"
"$SCRIPT_DIR/scripts/generate-ssh-key.sh" "$EMAIL"
"$SCRIPT_DIR/scripts/write-ssh-config.sh"
"$SCRIPT_DIR/scripts/set-symlinks.sh"
"$SCRIPT_DIR/scripts/write-git-config.sh"

BACKGROUNDS="$DOTFILES_DIR/backgrounds"
OMARCHY_BACKGROUNDS="$HOME/.config/omarchy/current/theme/backgrounds"

if [[ -d "$BACKGROUNDS" ]] && [[ -n "$(ls -A "$BACKGROUNDS" 2>/dev/null)" ]]; then
  mkdir -p "$OMARCHY_BACKGROUNDS"
  rsync -a --delete "$BACKGROUNDS/" "$OMARCHY_BACKGROUNDS/"
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
  ],
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

# TODO: Handle this in a better place
code --install-extension enkia.tokyo-night
code --install-extension golang.go
code --install-extension mhutchie.git-graph
code --install-extension bradlc.vscode-tailwindcss
code --install-extension oderwat.indent-rainbow
code --install-extension aaron-bond.better-comments
code --install-extension usernamehw.errorlens
code --install-extension ms-python.python
code --install-extension sumneko.lua
code --install-extension biomejs.biome
code --install-extension mechatroner.rainbow-csv

log "Files setup."
