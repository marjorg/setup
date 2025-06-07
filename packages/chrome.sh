#!/bin/bash

install() {
  if command -v google-chrome &> /dev/null; then
    return
  fi

  if [[ "$IS_LINUX" == "true" ]]; then
    execute curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/google-linux-keyring.gpg
    execute echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-linux-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
    execute sudo apt update
    install_apt google-chrome-stable
  elif [[ "$IS_MACOS" == "true" ]]; then
    install_brew_cask google-chrome
  fi
}
