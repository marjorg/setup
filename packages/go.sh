#!/bin/bash

LATEST_VERSION=$(curl -s https://go.dev/dl/?mode=json | \
  jq -r '[.[] | select(.stable == true)][0].version')

install_latest_linux() {
  execute curl -sSL "https://go.dev/dl/${LATEST_VERSION}.linux-amd64.tar.gz" -o /tmp/go.tar.gz
  execute sudo rm -rf /usr/local/go
  execute sudo tar -C /usr/local -xzf /tmp/go.tar.gz
  execute sudo rm /tmp/go.tar.gz
  export PATH=$PATH:/usr/local/go/bin
}

install() {
  if [[ "$IS_LINUX" == "true" ]]; then
    install_latest_linux
    # This currently breaks when running on Linux/WSL2
    # execute export PATH=$PATH:$HOME/go/bin
  elif [[ "$IS_MACOS" == "true" ]]; then
    install_brew go
  fi

  execute go install golang.org/x/tools/gopls@latest
}

update() {
  if ! command -v go &> /dev/null; then
    log "🚨 Go is not installed"
    exit 1
  fi

  CURRENT_VERSION=$(go version | awk '{print $3}')

  if [[ "$CURRENT_VERSION" == "$LATEST_VERSION" ]]; then
    debug "Go is already up to date"
    return
  fi

  if [[ "$IS_LINUX" == "true" ]]; then
    install_latest_linux
  fi
  
  execute go install golang.org/x/tools/gopls@latest
}
