#!/bin/bash

set -e
set -o pipefail

source shared.sh
source utilities.sh

if [[ "$IS_MAC" == true ]]; then
  TASKS_DIR="$DOTFILES_DIR/tasks/mac"
elif [[ "$IS_UBUNTU" == true ]]; then
  UBUNTU_VERSION=$(lsb_release -rs)

  case "$UBUNTU_VERSION" in
    24.04)
      TASKS_DIR="$DOTFILES_DIR/tasks/ubuntu/22.04"
      ;;
    *)
      echo "🚨 Unsupported Ubuntu version: $UBUNTU_VERSION" >&2
      exit 1
      ;;
  esac
elif [[ "$IS_ARCH" == true ]]; then
  TASKS_DIR="$DOTFILES_DIR/tasks/arch"
else
  echo "🚨 Unsupported OS/Distribution" >&2
  exit 1
fi

if [[ -f "$TASKS_DIR/00_prerequisites.sh" ]]; then
  source "$TASKS_DIR/00_prerequisites.sh"

  if declare -F install > /dev/null; then
    install
    unset -f install
  fi
fi

if [[ "$DEPS_ONLY" == false ]]; then
  if [[ "$WORK" == false ]]; then
    if [[ ! -f "$DOTFILES_DIR/modules/private/vault.yml" ]]; then
      echo "🚨 Private submodule required"
      echo "Generate SSH and GPG keys and add them to GitHub"
      echo "Then run: 'git submodule update --init --recursive'"
      exit 1
    fi

    read -sp "Vault password: " VAULT_PW
    echo

    VAULT_PW_FILE=$(mktemp)
    chmod 600 "$VAULT_PW_FILE"
    echo "$VAULT_PW" > "$VAULT_PW_FILE"

    ansible-playbook "$DOTFILES_DIR/main.yml" \
      -e "work_mode=$WORK" \
      -e "email=$EMAIL" \
      --vault-password-file "$VAULT_PW_FILE"
  else
    ansible-playbook "$DOTFILES_DIR/main.yml" \
      -e "work_mode=$WORK" \
      -e "email=$EMAIL"
  fi
fi

for task in "$TASKS_DIR"/*.sh; do
  if [[ -f "$task" ]]; then
    source "$task"
    TASK_NAME=$(basename "${task%.sh}")

    if $TASK_NAME == "00_prerequisites"; then
      continue
    fi

    if declare -F install > /dev/null; then
      debug "Running $TASK_NAME install..."
      install
      unset -f install
    fi
  fi
done

if [[ "$IS_LINUX" == true ]]; then
  if [[ "$SHELL" != "/usr/bin/zsh" ]]; then
    execute chsh -s $(which zsh)
    log "Changed default shell to zsh, restart terminal"
  else
    debug "Default shell is already zsh"
  fi
fi
