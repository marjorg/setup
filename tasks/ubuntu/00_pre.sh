#!/bin/bash

install() {
  sudo apt-get update
  sudo apt-get install curl \
    gnupg \
    gnupg2 \
    ansible \
    unzip \
    jq
}
