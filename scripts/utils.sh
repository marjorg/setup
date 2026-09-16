#!/bin/bash

set -euo pipefail

DOTFILES_DIR="$HOME/dotfiles"

LOG_FILE="$DOTFILES_DIR/install.log"
[[ -f "$LOG_FILE" ]] || : > "$LOG_FILE"

trap 'echo "Error at line $LINENO. Check $LOG_FILE for details." >&2' ERR

# Config rather than state, per the XDG base directory spec.
# https://specifications.freedesktop.org/basedir/latest/#variables
IDENTITY_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/identity"

DRY=false
DEBUG=false
WORK=false
EMAIL=""
NAME=""
UPDATE_MODE=false

while [[ $# > 0 ]]; do
  if [[ $1 == "--dry" ]]; then
    DRY=true
  elif [[ $1 == "--debug" ]]; then
    DEBUG=true
  elif [[ $1 == "--work" ]]; then
    WORK=true
  elif [[ $1 == "--name" ]]; then
    shift
    [[ $# -gt 0 ]] || { echo "Error: --name requires a value" >&2; exit 1; }
    NAME="$1"
  elif [[ $1 == "--email" ]]; then
    shift
    [[ $# -gt 0 ]] || { echo "Error: --email requires a value" >&2; exit 1; }
    EMAIL="$1"
  elif [[ $1 == "--update" ]]; then
    UPDATE_MODE=true
  fi

  shift
done

log() {
  local msg

  if $DRY; then
    msg="[DRY RUN] $@"
  else
    msg="$@"
  fi

  echo "$msg"
  echo "$msg" >> "$LOG_FILE"
}

debug() {
  if $DEBUG; then
    echo "[DEBUG] $@"
  fi
}

execute() {
  if $DRY; then
    log "$@"

  else
    if [[ "$1" == "eval" ]]; then
      eval "${@:2}"
    elif [[ "$1" == "capture" ]]; then
      "${@:2}"
    else
      "$@"
    fi
  fi
}

SAVED_NAME=""
SAVED_EMAIL=""

# Parsed, not sourced. Sourcing would run whatever ends up in this file.
load_identity() {
  [[ -f "$IDENTITY_FILE" ]] || return 0

  local key value

  # Tolerates a hand-seeded file with no trailing newline or with CRLF. A \r in
  # $EMAIL makes every GPG lookup miss, so a new key gets made on every run.
  while IFS='=' read -r key value || [[ -n "$key" ]]; do
    value="${value%$'\r'}"

    case "$key" in
      name) SAVED_NAME="$value" ;;
      email) SAVED_EMAIL="$value" ;;
    esac
  done < "$IDENTITY_FILE"
}

save_identity() {
  if $DRY; then
    log "Saving identity to $IDENTITY_FILE"
    return 0
  fi

  local dir="${IDENTITY_FILE%/*}"

  # 0700 is what the XDG spec asks for when creating a base directory.
  mkdir -p "$dir"
  chmod 700 "$dir"
  printf 'name=%s\nemail=%s\n' "$NAME" "$EMAIL" > "$IDENTITY_FILE"
  chmod 600 "$IDENTITY_FILE"
  debug "Identity saved to $IDENTITY_FILE"
}

# Answer lands here rather than on stdout, because `exit` inside a command
# substitution only kills the subshell.
IDENTITY_ANSWER=""

ask_identity() {
  local label="$1"

  IDENTITY_ANSWER=""

  if [[ ! -t 0 ]]; then
    echo "Error: $label is required. Pass --name/--email, or run this interactively to be asked once." >&2
    exit 1
  fi

  while [[ -z "$IDENTITY_ANSWER" ]]; do
    printf '%s: ' "$label" >&2

    # read exits non-zero on EOF (Ctrl-D); without this guard set -e kills the
    # caller with no message.
    read -r IDENTITY_ANSWER || {
      echo >&2
      echo "Error: no $label provided." >&2
      exit 1
    }
  done
}

# A --name/--email that contradicts the stored identity is usually a typo or a
# one-off work override, and saving it silently would repoint every later run.
confirm_identity_change() {
  local answer=""

  echo "Stored identity: $SAVED_NAME <$SAVED_EMAIL>" >&2
  echo "This run:        $NAME <$EMAIL>" >&2
  echo "Saving replaces the stored identity, so later runs without --name/--email will use the new values." >&2

  if [[ -t 0 ]]; then
    printf 'Save the new identity? [y/N] ' >&2
    read -r answer || answer=""
  fi

  case "$answer" in
    [yY] | [yY][eE][sS])
      return 0
      ;;
    *)
      log "Left $IDENTITY_FILE unchanged; the new values apply to this run only."
      return 1
      ;;
  esac
}

# Call only from scripts that need a name or email, so unrelated runs like
# ./install.sh never stop to ask.
require_identity() {
  load_identity

  [[ -n "$NAME" ]] || NAME="$SAVED_NAME"
  [[ -n "$EMAIL" ]] || EMAIL="$SAVED_EMAIL"

  if [[ -z "$NAME" ]]; then
    ask_identity "Full name (used for git commits and key identities)"
    NAME="$IDENTITY_ANSWER"
  fi

  if [[ -z "$EMAIL" ]]; then
    ask_identity "Email address (used for git commits and key identities)"
    EMAIL="$IDENTITY_ANSWER"
  fi

  [[ "$NAME" != "$SAVED_NAME" || "$EMAIL" != "$SAVED_EMAIL" ]] || return 0

  # Filling in a field the file never had isn't a conflict, so don't ask.
  if [[ -n "$SAVED_NAME" && "$NAME" != "$SAVED_NAME" ]] ||
    [[ -n "$SAVED_EMAIL" && "$EMAIL" != "$SAVED_EMAIL" ]]; then
    confirm_identity_change || return 0
  fi

  save_identity
}
