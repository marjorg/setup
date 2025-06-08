#!/bin/bash

install() {
  if [[ "$IS_LINUX" == "true" ]]; then
    install_apt sassc
    install_apt gtk2-engines-murrine
    install_apt gnome-themes-extra
  fi
}
