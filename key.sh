#!/bin/bash

set -e
set -o pipefail

IS_MAC=$(uname -s | grep -q Darwin && echo true || echo false)
IS_LINUX=$(uname -s | grep -q Linux && echo true || echo false)

if [[ "$IS_MAC" == "false" && "$IS_LINUX" == "false" ]]; then
  echo "🚨 Unsupported OS" >&2
  exit 1
fi

DOTFILES_DIR="$HOME/dotfiles"
SCRIPT_NAME=$(basename "$0")

if [[ "$0" != "$DOTFILES_DIR/$SCRIPT_NAME" && ! -d "$DOTFILES_DIR" ]]; then
  if ! [ -x "$(command -v git)" ]; then
    if [[ "$IS_MAC" == true ]]; then
      brew install git
    elif [[ "$IS_LINUX" == true ]]; then
      sudo apt-get install git -y
    fi

    echo "✅ Installed Git"
  fi

  read -sp "Github Token (Scopes: admin:public_key, repo): " GH_TOKEN
  echo

  KEY_TITLE="temp-setup-key-$(date +%s)"

  ssh-keygen -t ed25519 -C "$KEY_TITLE" -f /tmp/temp_github_key -N ""

  PUB_KEY_CONTENT=$(cat /tmp/temp_github_key.pub)
  ADD_KEY_PAYLOAD=$(jq -nc --arg title "$KEY_TITLE" --arg key "$PUB_KEY_CONTENT" '{title: $title, key: $key}')

  wget --header="Authorization: token $GH_TOKEN" \
       --header="Accept: application/vnd.github+json" \
       --header="Content-Type: application/json" \
       --method=POST \
       --body-data="$ADD_KEY_PAYLOAD" \
       -O /tmp/github_add_key_response.json \
       https://api.github.com/user/keys

  export GIT_SSH_COMMAND="ssh -i /tmp/temp_github_key -o IdentitiesOnly=yes"

  git clone --quiet --recurse-submodules https://github.com/marjorg/setup.git $DOTFILES_DIR
  git -C $DOTFILES_DIR submodule update --init --recursive

  KEY_ID=$(wget --header="Authorization: token $GH_TOKEN" \
                --header="Accept: application/vnd.github+json" \
                -O - https://api.github.com/user/keys | \
          jq ".[] | select(.title==\"$KEY_TITLE\") | .id")

  wget --header="Authorization: token $GH_TOKEN" \
        --header="Accept: application/vnd.github+json" \
        --method=DELETE \
        -O /dev/null \
        https://api.github.com/user/keys/"$KEY_ID"

  unset GIT_SSH_COMMAND
  shred -u /tmp/temp_github_key /tmp/temp_github_key.pub

  echo "✅ Cloned repository"
else
  if [ -z "$(git -C $DOTFILES_DIR status --porcelain)" ]; then
    git -C $DOTFILES_DIR pull --quiet
    git -C $DOTFILES_DIR submodule update --init --recursive
    echo "✅ Updated repository"
  else
    echo "⚠️ Local changes detected in dotfiles repository, skipping pull"
  fi
fi
