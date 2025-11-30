#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/scripts/utils.sh"

"$SCRIPT_DIR/scripts/generate-gpg-key.sh" "$EMAIL"
"$SCRIPT_DIR/scripts/generate-ssh-key.sh" "$EMAIL"
"$SCRIPT_DIR/scripts/write-ssh-config.sh"
"$SCRIPT_DIR/scripts/set-symlinks.sh"
#"$SCRIPT_DIR/scripts/write-git-config.sh"

BACKGROUNDS="$DOTFILES_DIR/backgrounds"
OMARCHY_BACKGROUNDS="$HOME/.config/omarchy/current/theme/backgrounds"


if [[ -d "$BACKGROUNDS" ]] && [[ -n "$(ls -A "$BACKGROUNDS" 2>/dev/null)" ]]; then
  mkdir -p "$OMARCHY_BACKGROUNDS"
  rsync -a --delete "$BACKGROUNDS/" "$OMARCHY_BACKGROUNDS/"
else
  log "Warning: Backgrounds directory empty or missing, skipping sync"
fi

log "Files setup."
