#!/bin/bash

install() {
  if [[ "$IS_LINUX" == "true" ]]; then
    install_apt lxappearance # To preview/edit themes/icons
    install_apt sassc
    install_apt gtk2-engines-murrine
    install_apt gnome-themes-extra
    execute sudo add-apt-repository ppa:papirus/papirus -y
    execute sudo apt-get update
    install_apt papirus-icon-theme
  fi
}
