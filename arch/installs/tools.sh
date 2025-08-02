#!/bin/bash

PACMAN_PACKAGES+=(
  btop
  fd
  fzf
  gcc
  gnupg
  imagemagick
  neovim
  protobuf
  ripgrep
  tmux
  zsh
  zoxide
  xdg-user-dirs
  man-db
  man-pages
  ufw # Firewall
  gufw # UFW GUI
  postgresql-libs # Postgres client tools
  unzip
  zip
  p7zip
  unrar
  xdg-desktop-portal # File manager integration in apps
  xdg-desktop-portal-gtk
)

post_install() {
  if [[ -d "$HOME/Desktop" ]]; then
    xdg-user-dirs-update
  fi

  if ! command -v oh-my-posh &> /dev/null; then
    curl -s https://ohmyposh.dev/install.sh | bash -s
  fi

  sudo ufw default deny incoming
  sudo ufw default allow outgoing
  sudo ufw enable

  sudo systemctl enable ufw
  sudo systemctl start ufw

  if pacman -Q xdg-desktop-portal-cosmic &> /dev/null; then
    sudo pacman -R --noconfirm xdg-desktop-portal-cosmic
  fi

  systemctl --user enable --now xdg-desktop-portal
  systemctl --user enable --now xdg-desktop-portal-gtk
}
