#!/bin/bash

install() {
  local packages_file="$DOTFILES_DIR/packages.json"

  if [[ "$IS_MAC" == true ]]; then
    install_package_type "$packages_file" '.homebrew != null' 'homebrew' install_brew
    install_package_type "$packages_file" '.homebrew_cask != null' 'homebrew_cask' install_brew_cask
    # MAS temporarily disabled due to https://github.com/mas-cli/mas/issues/724
    # install_package_type "Mac App Store apps" "$packages_file" '.mas != null' 'mas' install_mas_app
  elif [[ "$IS_LINUX" == true ]]; then
    install_package_type "$packages_file" '.apt != null' 'apt' install_apt
  fi
}
