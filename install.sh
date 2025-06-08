#!/bin/bash

set -e
set -o pipefail

source shared.sh

if [[ "$IS_MAC" == true ]]; then
  # Using command -v on xcode-select is untested, might have to use "if ! xcode-select -p &> /dev/null; then"
  if ! [ -x "$(command -v xcode-select)" ]; then
    execute xcode-select --install &> /dev/null

    # This section is untested
    until command -v xcode-select &> /dev/null; do
      execute sleep 5
    done

    log "✅ Installed XCode Command Line Tools"
  fi

  if ! [ -x "$(command -v brew)" ]; then
    execute /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    execute echo >> "$HOME/.zprofile"
    execute echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
    execute eval "$(/opt/homebrew/bin/brew shellenv)"

    log "✅ Installed Homebrew"
  fi

  execute brew update
  install_brew btop
  install_brew curl
  install_brew fd
  install_brew fzf
  install_brew gcc
  install_brew gh
  install_brew gnupg
  install_brew neovim
  install_brew ansible
  install_brew protobuf
  install_brew ripgrep
  install_brew jq
  install_brew mas
  install_brew 1password-cli
  install_brew tmux
  install_brew zsh
  install_brew imagemagick
  install_brew_cask discord
  install_brew_cask docker
  install_brew_cask figma
  install_brew_cask firefox
  install_brew_cask ghostty
  install_brew_cask imageoptim
  install_brew_cask jordanbaird-ice # Ice Menu Bar
  install_brew_cask karabiner-elements
  install_brew_cask obsidian
  install_brew_cask postman
  install_brew_cask raycast
  install_brew_cask redis-insight
  install_brew_cask spotify
  install_brew_cask tableplus
  install_brew_cask the-unarchiver
  install_brew_cask visual-studio-code
  install_mas 1569813296 # 1Password Safari
  install_mas 937984704 # Amphetamine
elif [[ "$IS_LINUX" == true ]]; then
  install_apt curl

  if ! [ -x "$(command -v op)" ]; then
    curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
      sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg && \
      echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" | \
      sudo tee /etc/apt/sources.list.d/1password.list && \
      sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/ && \
      curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | \
      sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol && \
      sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22 && \
      curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
      sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg
  fi

  execute sudo apt-get update
  install_apt btop
  install_apt fd-find
  install_apt fzf
  install_apt gcc
  install_apt gh
  install_apt wofi
  install_apt gnupg
  install_apt neovim
  install_apt ansible
  install_apt protobuf-compiler
  install_apt ripgrep
  install_apt unzip
  install_apt jq
  install_apt 1password-cli
  install_apt tmux
  install_apt zsh
  install_apt imagemagick
fi

for pkg in "$PACKAGES_DIR"/*.sh; do
  if [[ -f "$pkg" ]]; then
    source "$pkg"
    name=$(basename "${pkg%.sh}")

    if declare -F install > /dev/null; then
      install
      unset -f install
    else
      debug "Skipping $name – no install function"
    fi
  fi
done
