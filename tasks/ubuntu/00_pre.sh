#!/bin/bash

install() {
  sudo apt-get update
  sudo apt-get install -y curl \
    gnupg \
    gnupg2 \
    ansible \
    unzip \
    jq
}
