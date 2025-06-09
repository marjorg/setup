#!/bin/bash

#
# TODO: Clean this up, just dumped it here
#

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

if [[ ! "$IS_WORK" == true ]]; then
  install_mas 1569813296 # 1Password Safari
  install_mas 937984704 # Amphetamine
fi

install_brew jandedobbeleer/oh-my-posh/oh-my-posh
install_brew_cask 1password
install_brew_cask brave-browser
curl -fsSL https://bun.sh/install | bash
install_brew_cask google-chrome
install_brew_cask font-jetbrains-mono
install_brew_cask font-jetbrains-mono-nerd-font
install_brew go
execute go install golang.org/x/tools/gopls@latest
go install github.com/jesseduffield/lazygit@latest
 install_brew zoxide
