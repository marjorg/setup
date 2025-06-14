#!/bin/bash

install() {
  sudo pacman -Sy --noconfirm --needed go
  go install golang.org/x/tools/gopls@latest
}

update() {
  sudo pacman -Sy --noconfirm --needed go
  go install golang.org/x/tools/gopls@latest
}
