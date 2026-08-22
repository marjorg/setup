#!/bin/bash

pre_install() {
  if [[ "$(omarchy-theme-current)" != "Tokyo Night" ]]; then
    omarchy-theme-set "Tokyo Night"
  fi

  if [[ "$(omarchy-default-terminal)" != "ghostty" ]]; then
    omarchy-default-terminal ghostty
  fi

  if [[ "$(omarchy-default-editor)" != "code" ]]; then
    omarchy-default-editor code
  fi

  if [[ "$(omarchy-default-browser)" != "chromium" ]]; then
    omarchy-default-browser chromium
  fi
}
