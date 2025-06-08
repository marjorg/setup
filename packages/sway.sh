#!/bin/bash

install() {
  if [[ "$IS_LINUX" == "true" ]]; then
    install_apt sway
    install_apt swaylock
    install_apt swayidle
    install_apt mako-notifier
    # TODO: Does not exist for 22.04, temp using mako
    # install_apt sway-notification-center
  fi
}
