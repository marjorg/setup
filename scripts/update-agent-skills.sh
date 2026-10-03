#!/bin/bash

# Updates the skills, agents, commands and references vendored from
# addyosmani/agent-skills, and the single skills in SKILL_SOURCES. Pass a tag
# to pin an agent-skills version, else the latest tag is used. What is
# currently vendored is read from home/.agents/README.md.

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

# agent-skills path → local path. Upstream's top-level commands/ are Gemini TOML;
# the Markdown ones Claude Code and OpenCode read live under .claude/commands.
MAPPINGS=(
  "skills:skills"
  "agents:agents"
  "references:references"
  ".claude/commands:commands"
)

# Single skills as name|repo|path. Their repos don't tag releases, so each
# follows the last commit that changed its folder. A new one also needs a
# "- `name` from <url> (commit none)" line in the README.
SKILL_SOURCES=(
  "unslop|https://github.com/cursor/plugins|pstack/skills/unslop"
  "diagram-design|https://github.com/cathrynlavery/diagram-design|skills/diagram-design"
)
declare -A SKILL_CURRENT SKILL_TARGET

TARGET=""
for arg in "$@"; do
  [[ "$arg" == --* ]] || TARGET="$arg"
done

CURRENT="$(sed -n 's/.*(version \([0-9][0-9.]*\)).*/\1/p' "$README")"
if [[ -z "$CURRENT" ]]; then
  echo "Error: no \"(version X.Y.Z)\" found in $README" >&2
  exit 1
fi

for source in "${SKILL_SOURCES[@]}"; do
  IFS='|' read -r name _ _ <<< "$source"
  SKILL_CURRENT[$name]="$(sed -n "s/^- \`$name\` .*(commit \([0-9a-f]\+\|none\)).*/\1/p" "$README")"
  if [[ -z "${SKILL_CURRENT[$name]}" ]]; then
    echo "Error: no \"- \`$name\` ... (commit SHA)\" line found in $README" >&2
    exit 1
  fi
done

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

skills_current=true
for source in "${SKILL_SOURCES[@]}"; do
  IFS='|' read -r name repo path <<< "$source"
  log "Fetching $repo"
  git clone --quiet --filter=blob:none "$repo" "$WORK_DIR/sources/$name"

  SKILL_TARGET[$name]="$(git -C "$WORK_DIR/sources/$name" log -1 --format=%h --abbrev=7 -- "$path")"
  if [[ -z "${SKILL_TARGET[$name]}" ]]; then
    echo "Error: $repo has no $path" >&2
    exit 1
  fi
  [[ "${SKILL_TARGET[$name]}" == "${SKILL_CURRENT[$name]}" ]] || skills_current=false
done

# Naming the vendored version re-syncs it, which resets hand edits and clears
# out stale files without waiting for a new release.
if [[ -z "$TARGET" ]]; then
  TARGET="$(git -C "$WORK_DIR/repo" tag --sort=-v:refname | head -n 1)"

  if [[ "$TARGET" == "$CURRENT" ]] && $skills_current; then
    log "agent-skills $CURRENT and every single skill are already up to date"
    exit 0
  fi
fi

if ! git -C "$WORK_DIR/repo" rev-parse --verify --quiet "refs/tags/$TARGET" > /dev/null; then
  echo "Error: upstream has no tag $TARGET" >&2
  exit 1
fi

log "Updating agent-skills $CURRENT → $TARGET"
for source in "${SKILL_SOURCES[@]}"; do
  IFS='|' read -r name _ _ <<< "$source"
  log "Updating $name ${SKILL_CURRENT[$name]} → ${SKILL_TARGET[$name]}"
done

# Patches every upstream file needs to work here, unlike hand edits, which
# are optional.
patch_tree() {
  local dir=$1
  local f

  # Skills are installed loose, not as a plugin, so the plugin namespace in
  # "invoke the agent-skills:foo skill" doesn't resolve.
  grep -rlZ "agent-skills:" "$dir/commands" | xargs -0 -r sed -i 's/agent-skills://g'

  # AGENTS.md is the one rules file here; Claude Code reads it through a
  # CLAUDE.md symlink. Pairs naming both are collapsed first so the swap
  # doesn't leave "AGENTS.md and AGENTS.md".
  # shellcheck disable=SC2016  # the backticks are Markdown
  grep -rlZ "CLAUDE\.md" "$dir" | xargs -0 -r sed -E -i \
    -e 's/(`?)AGENTS\.md\1 (and|or) `?CLAUDE\.md`?/\1AGENTS.md\1/g' \
    -e 's/(`?)CLAUDE\.md\1, `?AGENTS\.md`?/\1AGENTS.md\1/g' \
    -e 's/CLAUDE\.md/AGENTS.md/g'

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

  # pstack turned off model invocation for unslop, so it would only run when
  # typed as /unslop. It's meant to cover every piece of writing.
  sed -i '/^disable-model-invocation:/d' "$dir/skills/unslop/SKILL.md"
}

NEW="$WORK_DIR/new"

extract() {
  local repo=$1 ref=$2 src=$3 dest=$4

  mkdir -p "$NEW/$dest"
  git -C "$repo" archive "$ref" "$src" |
    tar -x -C "$NEW/$dest" --strip-components="$(tr -cd / <<< "$src/" | wc -c)"
}

for mapping in "${MAPPINGS[@]}"; do
  extract "$WORK_DIR/repo" "$TARGET" "${mapping%%:*}" "${mapping#*:}"
done
for source in "${SKILL_SOURCES[@]}"; do
  IFS='|' read -r name _ path <<< "$source"
  extract "$WORK_DIR/sources/$name" "${SKILL_TARGET[$name]}" "$path" "skills/$name"
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

readme_edits=(-e "s/(version $CURRENT)/(version $TARGET)/")
for source in "${SKILL_SOURCES[@]}"; do
  IFS='|' read -r name _ _ <<< "$source"
  readme_edits+=(-e "/^- \`$name\` /s/(commit ${SKILL_CURRENT[$name]})/(commit ${SKILL_TARGET[$name]})/")
done
execute sed -i "${readme_edits[@]}" "$README"

log "agent-skills $TARGET and ${#SKILL_SOURCES[@]} single skills: $updated updated, $added added, $removed removed"
log "Hand edits were overwritten. Review with git diff, and bring back the ones to keep with: git -C $DOTFILES_DIR restore -p -- home/.agents"
