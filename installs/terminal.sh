#!/bin/bash

PACMAN_PACKAGES+=(
  ghostty
  tmux
  zsh
  yazi
  7zip
  poppler
  resvg
  rsync
  wl-clipboard
)

YAY_PACKAGES+=(
  oh-my-posh-bin
)

post_install() {
  TPM_DIR="$HOME/.tmux/plugins/tpm"

  if [[ ! -d "$TPM_DIR" ]]; then
    git clone --quiet https://github.com/tmux-plugins/tpm "$TPM_DIR"
  else
    git -C "$TPM_DIR" pull --quiet
  fi
}
