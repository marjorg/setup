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
elif [[ "$IS_LINUX" == true ]]; then
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
fi

if [[ "$IS_MAC" == true ]]; then
  install_package_type "$PACKAGES_FILE" '.homebrew != null' 'homebrew' install_brew
  install_package_type "$PACKAGES_FILE" '.homebrew_cask != null' 'homebrew_cask' install_brew_cask
  # MAS temporarily disabled due to https://github.com/mas-cli/mas/issues/724
  # install_package_type "Mac App Store apps" "$PACKAGES_FILE" '.mas != null' 'mas' install_mas_app
elif [[ "$IS_LINUX" == true ]]; then
  install_package_type "$PACKAGES_FILE" '.apt != null' 'apt' install_apt
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
