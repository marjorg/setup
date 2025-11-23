#!/bin/bash

pre_install() {
  if [[ "$(omarchy-theme-current)" != "Tokyo Night" ]]; then
    omarchy-theme-set "Tokyo Night"
  fi
}
