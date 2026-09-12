#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh" "$@"

set -euo pipefail

SETTINGS="$HOME/.claude/settings.json"
# Stored unexpanded: Claude runs this through a shell, and the literal ~ keeps
# the setting portable across machines.
# shellcheck disable=SC2088
STATUSLINE="~/.claude/statusline.sh"

mkdir -p "$(dirname "$SETTINGS")"
[[ -f "$SETTINGS" ]] || echo '{}' > "$SETTINGS"

# Claude rewrites this file itself, so bail rather than clobber a broken one.
if ! jq empty "$SETTINGS" 2>/dev/null; then
  log "Warning: Claude settings.json is not valid JSON, skipping status line"
  exit 0
fi

CURRENT=$(jq -r '.statusLine.command // ""' "$SETTINGS")

if [[ "$CURRENT" == "$STATUSLINE" ]]; then
  debug "Claude status line already configured"
  exit 0
fi

[[ -n "$CURRENT" ]] && log "Replacing existing Claude status line: $CURRENT"

if $DRY; then
  log "Set statusLine to $STATUSLINE in $SETTINGS"
  exit 0
fi

TMP=$(mktemp)
trap 'rm -f "$TMP"' EXIT

jq --arg cmd "$STATUSLINE" \
  '.statusLine = {type: "command", command: $cmd}' "$SETTINGS" > "$TMP"
mv "$TMP" "$SETTINGS"

log "Claude status line configured."
