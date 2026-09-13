#!/bin/bash
# Claude Code status line: model · context used · cwd · worktree · git branch
# Reads the status line JSON payload on stdin, writes one line to stdout.

set -uo pipefail

PAYLOAD=$(cat)

IFS=$'\t' read -r MODEL PERCENT TOKENS CWD <<<"$(
  printf '%s' "$PAYLOAD" | /usr/bin/jq -r '
    [ (.model.display_name // "?"),
      ((.context_window.used_percentage // -1) | floor),
      (.context_window.total_input_tokens // -1),
      (.workspace.current_dir // .cwd // "?")
    ] | @tsv'
)"

DIM=$'\033[2m'
RESET=$'\033[0m'
SEP="${DIM} · ${RESET}"

# Token counts read better abbreviated than in full.
abbrev() {
  local n=$1
  if ((n >= 1000000)); then
    printf '%d.%dM' $((n / 1000000)) $(((n % 1000000) / 100000))
  elif ((n >= 1000)); then
    printf '%dk' $((n / 1000))
  else
    printf '%d' "$n"
  fi
}

# Green until the window is half gone, amber on approach, red near compaction.
context_field() {
  ((PERCENT < 0)) && return

  local color
  if ((PERCENT >= 80)); then
    color=$'\033[31m'
  elif ((PERCENT >= 50)); then
    color=$'\033[33m'
  else
    color=$'\033[32m'
  fi

  local field="${color}${PERCENT}%${RESET}"
  ((TOKENS >= 0)) && field+=" ${DIM}$(abbrev "$TOKENS")${RESET}"
  printf '%s' "$field"
}

# Detached HEAD has no branch name, so fall back to the short commit.
branch_field() {
  git -C "$CWD" rev-parse --is-inside-work-tree &>/dev/null || return

  local branch
  branch=$(git -C "$CWD" symbolic-ref --quiet --short HEAD 2>/dev/null) ||
    branch=$(git -C "$CWD" rev-parse --short HEAD 2>/dev/null) ||
    return

  printf '\033[35m%s\033[0m' "$branch"
}

# Only linked worktrees have a git dir apart from the shared one; the main checkout shows nothing.
worktree_field() {
  local git_dir common_dir
  git_dir=$(git -C "$CWD" rev-parse --path-format=absolute --git-dir 2>/dev/null) || return
  common_dir=$(git -C "$CWD" rev-parse --path-format=absolute --git-common-dir 2>/dev/null) || return
  [[ "$git_dir" != "$common_dir" ]] || return

  printf '\033[36m⎇ %s\033[0m' "$(basename "$(git -C "$CWD" rev-parse --show-toplevel)")"
}

FIELDS=("$MODEL" "$(context_field)" "${CWD/#$HOME/\~}" "$(worktree_field)" "$(branch_field)")

LINE=""
for field in "${FIELDS[@]}"; do
  [[ -n "$field" ]] || continue
  [[ -n "$LINE" ]] && LINE+="$SEP"
  LINE+="$field"
done

printf '%s\n' "$LINE"
