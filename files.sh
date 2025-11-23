#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/scripts/utils.sh"

"$SCRIPT_DIR/scripts/generate-gpg-key.sh"
"$SCRIPT_DIR/scripts/generate-ssh-key.sh"
"$SCRIPT_DIR/scripts/write-ssh-config.sh"
"$SCRIPT_DIR/scripts/set-symlinks.sh"

log "Files setup."
