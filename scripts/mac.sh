#!/bin/bash

setup_mac() {
  log "⌛ Starting MacOS setup..."

  # Using command -v on xcode-select is untested, might have to use "if ! xcode-select -p &> /dev/null; then"
  if ! [ -x "$(command -v xcode-select)" ]; then
    execute xcode-select --install &> /dev/null

    # This section is untested
    until command -v xcode-select &> /dev/null; do
      execute sleep 5
    done

    log "✅ Installed XCode Command Line Tools"
  fi

  if ! [ -x "$(command -v jq)" ]; then
    execute brew install jq
    log "✅ Installed jq"
  fi

  if ! [ -x "$(command -v brew)" ]; then
    execute /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    execute echo >> "$HOME/.zprofile"
    execute echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
    execute eval "$(/opt/homebrew/bin/brew shellenv)"

    log "✅ Installed Homebrew"
  fi

  if ! [ -x "$(command -v mas)" ]; then
    execute brew install mas
    log "✅ Installed Mac App Store CLI"
  fi

  if ! [ -x "$(command -v op)" ]; then
    execute brew install 1password-cli
    log "✅ Installed 1Password CLI"
  fi

  if ! [ -x "$(command -v git)" ]; then
    execute brew install git
    log "✅ Installed Git"
  fi

  if ! [ -x "$(command -v ansible)" ]; then
    execute brew install ansible
    log "✅ Installed Ansible"
  fi

  log "✅ Completed MacOS setup"
}
