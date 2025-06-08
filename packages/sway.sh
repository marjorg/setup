#!/bin/bash

install() {
  if [[ "$IS_LINUX" == "true" ]]; then
    install_apt sway
    install_apt swaylock
    install_apt swayidle

    # When updating to Ubuntu 23+ this can be replaced by install_apt sway-notification-center
    install_apt mako-notifier
  fi
}
