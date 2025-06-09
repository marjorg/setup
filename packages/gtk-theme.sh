#!/bin/bash

install() {
  if [[ "$IS_LINUX" == "true" ]]; then
    execute sudo add-apt-repository ppa:papirus/papirus -y
    execute sudo apt-get update
  fi

  install_apt lxappearance # To preview/edit themes/icons
  install_apt sassc
  install_apt gtk2-engines-murrine
  install_apt gnome-themes-extra
  install_apt papirus-icon-theme
}
