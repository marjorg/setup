#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh" "$@"

set -euo pipefail

if ! is_omarchy; then
  log "Skipping login logo, Plymouth theming is Omarchy-only."
  exit 0
fi

# Rendered from home/.config/omarchy/branding/screensaver.txt in Adwaita Mono
# at 10pt, since JetBrains Mono's ligatures merge runs like == and ** and wreck
# the art.
LOGO="$DOTFILES_DIR/branding/login-logo.png"
INSTALLED_LOGO="/usr/share/plymouth/themes/omarchy/logo.png"
PLYMOUTH_CONF="/etc/plymouth/plymouthd.conf"

# The art's colour is baked into the PNG, so these stay fixed to match it
# rather than following the current theme.
BG="#1a1b26"
FG="#a9b1d6"

scale_pinned() {
  grep -qx 'DeviceScale=1' "$PLYMOUTH_CONF"
}

if cmp -s "$LOGO" "$INSTALLED_LOGO" && scale_pinned; then
  debug "Login logo already up to date"
  exit 0
fi

# Plymouth's automatic scaling upscales the whole screen, which pixelates the
# thin ASCII art and blows up the password field. omarchy-settings upgrades
# reset this file along with the logo, so both are checked on every run.
if ! scale_pinned; then
  execute sudo sed -i '/^\[Daemon\]/a DeviceScale=1' "$PLYMOUTH_CONF"
fi

# Also rebuilds the initramfs, which is what picks up the plymouthd.conf change.
execute omarchy plymouth set "$BG" "$FG" "$LOGO"
log "Login logo set."
