#!/bin/bash

DOTFILES_DIR="$HOME/dotfiles"

if [[ "$(uname)" == "Darwin" ]]; then
  # Using command -v on xcode-select is untested, might have to use "if ! xcode-select -p &> /dev/null; then"
  if ! [ -x "$(command -v xcode-select)" ]; then
    xcode-select --install &> /dev/null

    # This section is untested
    until command -v xcode-select &> /dev/null; do
      sleep 5
    done

    echo "✅ Installed XCode Command Line Tools"
  else
    echo "🟡 XCode Command Line Tools already installed"
  fi

  if ! [ -x "$(command -v brew)" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "✅ Installed Homebrew"
  else
    echo "🟡 Homebrew already installed"
  fi

  if ! [ -x "$(command -v mas)" ]; then
    brew install mas
    echo "✅ Installed Mac App Store CLI"
  else
    echo "🟡 Mac App Store CLI already installed"
  fi

  if ! [ -x "$(command -v git)" ]; then
    brew install git
    echo "✅ Installed Git"
  else
    echo "🟡 Git already installed"
  fi

  if ! [ -x "$(command -v ansible)" ]; then
    brew install ansible
    ansible-galaxy collection install community.general
    echo "✅ Installed Ansible"
  else
    echo "🟡 Ansible already installed"
  fi
else
  echo "🚨 Unsupported OS"
  exit 1
fi

if ! [[ -d "$DOTFILES_DIR" ]]; then
  git clone --quiet https://github.com/marjorg/setup.git $DOTFILES_DIR
  echo "✅ Cloned repository"
else
  git -C $DOTFILES_DIR pull --quiet
  echo "🟡 Updated repository"
fi

# TODO: Integrate with 1pass?
ansible-playbook "$DOTFILES_DIR/main.yml" --vault-id=ssh@prompt --vault-id=env@prompt --vault-id=gpg@prompt
