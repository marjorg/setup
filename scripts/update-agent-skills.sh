#!/bin/bash

# Updates the skills, agents, commands and references vendored from
# addyosmani/agent-skills. Pass a tag to pin a version, else the latest tag is
# used. The version currently vendored is read from home/.agents/README.md.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh" "$@"

set -euo pipefail

UPSTREAM_REPO="https://github.com/addyosmani/agent-skills"
AGENTS_DIR="$DOTFILES_DIR/home/.agents"
README="$AGENTS_DIR/README.md"
# What the last update installed, so the next one knows what it may delete:
# skill folders, and single files elsewhere, since agents/ and commands/ can
# hold local ones too. Anything not listed is a local addition.
MANIFEST="$AGENTS_DIR/.vendored-files"

# Upstream path → local path. Upstream's top-level commands/ are Gemini TOML;
# the Markdown ones Claude Code and OpenCode read live under .claude/commands.
MAPPINGS=(
  "skills:skills"
  "agents:agents"
  "references:references"
  ".claude/commands:commands"
)

TARGET=""
for arg in "$@"; do
  [[ "$arg" == --* ]] || TARGET="$arg"
done

CURRENT="$(sed -n 's/.*(version \([0-9][0-9.]*\)).*/\1/p' "$README")"
if [[ -z "$CURRENT" ]]; then
  echo "Error: no \"(version X.Y.Z)\" found in $README" >&2
  exit 1
fi

# Upstream overwrites hand edits, so start from a clean tree. Then git diff
# shows exactly what was lost, and git restore -p brings back what to keep.
if ! $DRY && [[ -n "$(git -C "$DOTFILES_DIR" status --porcelain -- "$AGENTS_DIR")" ]]; then
  echo "Error: $AGENTS_DIR has uncommitted changes. Commit or stash them first." >&2
  exit 1
fi

WORK_DIR="$(mktemp -d)"
trap 'rm -rf "$WORK_DIR"' EXIT

log "Fetching $UPSTREAM_REPO"
git clone --quiet --filter=blob:none "$UPSTREAM_REPO" "$WORK_DIR/repo"

# Naming the vendored version re-syncs it, which resets hand edits and clears
# out stale files without waiting for a new release.
if [[ -z "$TARGET" ]]; then
  TARGET="$(git -C "$WORK_DIR/repo" tag --sort=-v:refname | head -n 1)"

  if [[ "$TARGET" == "$CURRENT" ]]; then
    log "agent-skills is already at $CURRENT"
    exit 0
  fi
fi

if ! git -C "$WORK_DIR/repo" rev-parse --verify --quiet "refs/tags/$TARGET" > /dev/null; then
  echo "Error: upstream has no tag $TARGET" >&2
  exit 1
fi

log "Updating agent-skills $CURRENT → $TARGET"

# Patches every upstream file needs to work here, unlike hand edits, which
# are optional.
patch_tree() {
  local dir=$1
  local f

  # Skills are installed loose, not as a plugin, so the plugin namespace in
  # "invoke the agent-skills:foo skill" doesn't resolve.
  grep -rlZ "agent-skills:" "$dir/commands" | xargs -0 -r sed -i 's/agent-skills://g'

  # /plan collides with the built-in plan mode command in both harnesses.
  if [[ -f "$dir/commands/plan.md" ]]; then
    mv "$dir/commands/plan.md" "$dir/commands/planning.md"
  fi

  # OpenCode treats agents without a mode as primary agents.
  for f in "$dir"/agents/*.md; do
    grep -q '^mode:' "$f" && continue
    awk '{ print } !done && /^name:/ { print "mode: subagent"; done = 1 }' "$f" > "$f.tmp"
    mv "$f.tmp" "$f"
  done
}

NEW="$WORK_DIR/new"

for mapping in "${MAPPINGS[@]}"; do
  mkdir -p "$NEW/${mapping#*:}"
  git -C "$WORK_DIR/repo" archive "$TARGET" "${mapping%%:*}" |
    tar -x -C "$NEW/${mapping#*:}" --strip-components="$(tr -cd / <<< "${mapping%%:*}/" | wc -c)"
done

patch_tree "$NEW"

updated=0
added=0
removed=0

while IFS= read -r rel; do
  local_file="$AGENTS_DIR/$rel"

  if [[ ! -f "$local_file" ]]; then
    execute install -D -m 644 "$NEW/$rel" "$local_file"
    added=$((added + 1))
    log "Added: $rel"
  elif ! cmp -s "$NEW/$rel" "$local_file"; then
    execute cp "$NEW/$rel" "$local_file"
    updated=$((updated + 1))
    log "Updated: $rel"
  fi
done < <(find "$NEW" -type f -printf '%P\n' | sort)

remove() {
  execute rm -rf "$AGENTS_DIR/$1"
  removed=$((removed + 1))
  log "Removed: $1"
}

if [[ -f "$MANIFEST" ]]; then
  while IFS= read -r entry; do
    # A blank line would otherwise mirror all of $AGENTS_DIR.
    [[ "$entry" =~ ^(skills/[^/]+|(agents|commands|references)/.+)$ && "$entry" != *..* ]] || continue
    [[ -e "$AGENTS_DIR/$entry" ]] || continue

    if [[ ! -e "$NEW/$entry" ]]; then
      remove "$entry"
    elif [[ -d "$NEW/$entry" ]]; then
      while IFS= read -r rel; do
        [[ -f "$NEW/$entry/$rel" ]] || remove "$entry/$rel"
      done < <(cd "$AGENTS_DIR/$entry" && find . -type f -printf '%P\n' | sort)
    fi
  done < "$MANIFEST"
else
  log "No $MANIFEST yet, so nothing is removed this time"
fi

if $DRY; then
  log "Writing $MANIFEST"
else
  (cd "$NEW" && { find skills -mindepth 1 -maxdepth 1; find agents commands references -type f; } | sort) > "$MANIFEST"
  find "${MAPPINGS[@]/#*:/$AGENTS_DIR/}" -mindepth 1 -type d -empty -delete
fi

execute sed -i "s/(version $CURRENT)/(version $TARGET)/" "$README"

log "agent-skills $TARGET: $updated updated, $added added, $removed removed"
log "Hand edits were overwritten. Review with git diff, and bring back the ones to keep with: git -C $DOTFILES_DIR restore -p -- home/.agents"
