#!/bin/bash

LATEST_VERSION=$(curl -s https://go.dev/dl/?mode=json | \
  jq -r '[.[] | select(.stable == true)][0].version')

install_latest() {
  curl -sSL "https://go.dev/dl/${LATEST_VERSION}.linux-amd64.tar.gz" -o /tmp/go.tar.gz
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf /tmp/go.tar.gz
  sudo rm /tmp/go.tar.gz
  export PATH=$PATH:/usr/local/go/bin
}

install() {
  install_latest
  # This currently breaks when running on Linux/WSL2
  # execute export PATH=$PATH:$HOME/go/bin

  go install golang.org/x/tools/gopls@latest
}

update() {
  CURRENT_VERSION=$(go version | awk '{print $3}')

  if [[ "$CURRENT_VERSION" == "$LATEST_VERSION" ]]; then
    debug "Go is already up to date"
    return
  fi

  install_latest

  go install golang.org/x/tools/gopls@latest
}
