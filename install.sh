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
    # TODO: Delete this after, only needed before zsh is setup
    echo >> "$HOME/.zprofile"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
    eval "$(/opt/homebrew/bin/brew shellenv)"

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

  if ! [ -x "$(command -v op)" ]; then
    brew install 1password-cli
    echo "✅ Installed 1Password CLI"
  else
    echo "🟡 1Password CLI already installed"
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

if ! op account get >/dev/null 2>&1; then
  echo "Sign in to 1Password CLI"
  eval $(op signin)
  echo "✅ Signed in to 1Password CLI"
else
  echo "🟡 Already signed in to 1Password CLI"
fi

SSH_PASS=$("$DOTFILES_DIR/scripts/get-op-vault-password.sh" zt523aidyr72aidluibpvs5zxy)
ENV_PASS=$("$DOTFILES_DIR/scripts/get-op-vault-password.sh" o5pckyjgmw7y5v4clccfhrq2ky)
GPG_PASS=$("$DOTFILES_DIR/scripts/get-op-vault-password.sh" i3uhsfzvqjtgxx2iqszjkv6hri)

ansible-playbook "$DOTFILES_DIR/main.yml" \
  --vault-id=ssh@<(echo "$SSH_PASS") \
  --vault-id=env@<(echo "$ENV_PASS") \
  --vault-id=gpg@<(echo "$GPG_PASS")
