#!/bin/bash

set -e
set -o pipefail

source shared.sh
source utilities.sh

if [[ ! -d "$DOTFILES_DIR/modules/private/vault.yml" ]]; then
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

  # TODO: These trigger a yes prompt, can that be auto?
#  git clone --quiet --recurse-submodules https://github.com/marjorg/setup.git $DOTFILES_DIR
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

  echo "✅ Cloned submodules"
fi

read -sp "Vault password: " VAULT_PW
echo

VAULT_PW_FILE=$(mktemp)
chmod 600 "$VAULT_PW_FILE"
echo "$VAULT_PW" > "$VAULT_PW_FILE"

ansible-playbook "$DOTFILES_DIR/main.yml" \
  -e "work_mode=$WORK" \
  --vault-password-file "$VAULT_PW_FILE"

if [[ "$IS_LINUX" == true ]]; then
  if [[ "$SHELL" != "/usr/bin/zsh" ]]; then
    execute chsh -s $(which zsh)
    log "Changed default shell to zsh, restart terminal"
  else
    debug "Default shell is already zsh"
  fi
fi
