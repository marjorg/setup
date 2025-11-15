#!/bin/bash

PACMAN_PACKAGES+=(
  ghostty
  tmux
  zsh
)

YAY_PACKAGES+=(
  oh-my-posh-bin
)

# TODO: Post: Update default terminal in omarchy settings, see https://github.com/basecamp/omarchy/blob/e58569b947012eed458488e8c7777c5da27f7a9c/bin/omarchy-install-terminal

post_install() {
  TPM_DIR="$HOME/.tmux/plugins/tpm"

  if [[ ! -d "$TPM_DIR" ]]; then
    git clone --quiet https://github.com/tmux-plugins/tpm "$TPM_DIR"
  else
    git -C "$TPM_DIR" pull --quiet
  fi
}
