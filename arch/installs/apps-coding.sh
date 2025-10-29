#!/bin/bash

YAY_PACKAGES+=(
  visual-studio-code-bin
  sublime-text-4
  tableplus
  postman-bin
  hoppscotch-bin
  redisinsight-bin
)

# TODO: Change default editor to vscode in omarchy, see:
# https://github.com/basecamp/omarchy/blob/e58569b947012eed458488e8c7777c5da27f7a9c/bin/omarchy-install-vscode
# https://github.com/basecamp/omarchy/blob/e58569b947012eed458488e8c7777c5da27f7a9c/config/uwsm/default#L7
#     • ~/.config/uwsm/default
#        ◦ EDITOR=code

PACMAN_PACKAGES+=(
  zed
)
