#!/bin/bash

install() {
  if ! command -v bun &> /dev/null; then
    curl -fsSL https://bun.sh/install | bash
  fi

  # GNOME file manager
  sudo pacman -Sy --noconfirm --needed gvfs gvfs-smb gvfs-mtp nautilus
  xdg-mime default org.gnome.Nautilus.desktop inode/directory
}
