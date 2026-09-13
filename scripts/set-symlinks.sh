#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh" "$@"

set -euo pipefail

DOTFILES_HOME="$HOME/dotfiles/home"
DOTFILES_CONFIG="$HOME/dotfiles/home/.config"
HOME_CONFIG="$HOME/.config"
LOCAL_BIN="$HOME/.local/bin"

link() {
  local src=$1
  local dest=$2

  mkdir -p "$(dirname "$dest")"

  # ln -sfn onto a real directory creates the link inside it instead of
  # replacing it, so move the directory out of the way first.
  if [[ -d "$dest" && ! -L "$dest" ]]; then
    log "Renaming existing directory: $dest → ${dest}.bak"
    mv "$dest" "${dest}.bak"
  fi

  ln -sfn "$src" "$dest"
  debug "Linked: $dest → $src"
}

link "$DOTFILES_HOME/.zshrc" "$HOME/.zshrc"
link "$DOTFILES_HOME/.profile" "$HOME/.profile"
link "$DOTFILES_HOME/.agents" "$HOME/.agents"
link "$DOTFILES_HOME/.claude/statusline.sh" "$HOME/.claude/statusline.sh"
link "$DOTFILES_HOME/.claude/settings.json" "$HOME/.claude/settings.json"
link "$DOTFILES_HOME/.agents/commands" "$HOME/.claude/commands"
link "$DOTFILES_HOME/.agents/agents" "$HOME/.claude/agents"

link /usr/bin/zeditor "$LOCAL_BIN/zed"

link "$DOTFILES_CONFIG/Code/User/keybindings.json" "$HOME_CONFIG/Code/User/keybindings.json"
link "$DOTFILES_CONFIG/Code/User/settings.json" "$HOME_CONFIG/Code/User/settings.json"
link "$DOTFILES_CONFIG/omarchy/branding/screensaver.txt" "$HOME_CONFIG/omarchy/branding/screensaver.txt"
link "$DOTFILES_CONFIG/omarchy/shell.json" "$HOME_CONFIG/omarchy/shell.json"
link "$DOTFILES_CONFIG/omarchy/defaults/agent" "$HOME_CONFIG/omarchy/defaults/agent"
link "$DOTFILES_CONFIG/xdg-terminals.list" "$HOME_CONFIG/xdg-terminals.list"
link "$DOTFILES_CONFIG/opencode/opencode.json" "$HOME_CONFIG/opencode/opencode.json"
link "$DOTFILES_HOME/.agents/commands" "$HOME_CONFIG/opencode/commands"
link "$DOTFILES_HOME/.agents/agents" "$HOME_CONFIG/opencode/agents"

for d in "$DOTFILES_CONFIG"/*/; do
  folder=$(basename "$d")

  case "$folder" in
    Code|omarchy|opencode)
      continue
      ;;
  esac

  dest="$HOME_CONFIG/$folder"

  if [[ -L "$dest" ]]; then
    debug "Skip: $folder (already symlink)"
    continue
  fi

  if [[ -d "$dest" ]]; then
    if [[ -e "${dest}.bak" ]]; then
      debug "Backup already exists, removing old directory: $dest"
      rm -rf "$dest"
    else
      log "Renaming existing directory: $dest → ${dest}.bak"
      mv "$dest" "${dest}.bak"
    fi
  fi

  link "$d" "$dest"
done

CLAUDE_SKILLS="$HOME/.claude/skills"
AGENT_SKILLS="$DOTFILES_HOME/.agents/skills"

mkdir -p "$CLAUDE_SKILLS"

# Skills are linked one by one, so ../../references inside a skill only
# resolves if references also sits beside the skills dir.
link "$DOTFILES_HOME/.agents/references" "$HOME/.claude/references"

for skill in "$AGENT_SKILLS"/*; do
  [[ -e "$skill" ]] || continue
  link "$skill" "$CLAUDE_SKILLS/$(basename "$skill")"
done

# Drop links left behind by skills that were removed from .agents
for l in "$CLAUDE_SKILLS"/*; do
  [[ -L "$l" ]] || continue
  [[ -e "$l" ]] && continue
  log "Removing stale skill link: $l"
  rm "$l"
done
