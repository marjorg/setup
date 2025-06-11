#!/bin/bash

install() {
  sudo add-apt-repository ppa:papirus/papirus -y
  sudo apt-get update

  # Papirus Icon theme
  # lxappearance: Preview/edit themes/icons
  sudo apt-get install -y \
    lxappearance \
    sassc \
    gtk2-engines-murrine \
    gnome-themes-extra \
    papirus-icon-theme

  sudo apt-get install -y \
    sway \
    swaylock \
    swayidle \
    wofi \
    waybar

  # When updating to Ubuntu 23+ this (deps below, +wayland-protocols & mako) can be replaced by install_apt sway-notification-center
  sudo apt-get install -y \
    meson \
    libwayland-dev \
    libpango1.0-dev \
    libcairo2-dev \
    libsystemd-dev \
    libgdk-pixbuf2.0-dev \
    libdbus-1-dev

  rm -rf wayland-protocols-1.32.tar.xz wayland-protocols-1.32
  wget https://gitlab.freedesktop.org/wayland/wayland-protocols/-/releases/1.32/downloads/wayland-protocols-1.32.tar.xz
  tar -xf wayland-protocols-1.32.tar.xz
  cd wayland-protocols-1.32
  meson setup build --prefix=/usr --buildtype=release
  ninja -C build
  sudo ninja -C build install
  cd ..
  rm -rf wayland-protocols-1.32.tar.xz wayland-protocols-1.32

  if ! command -v mako &> /dev/null; then
    rm -rf mako
    git clone https://github.com/emersion/mako.git
    cd mako
    meson build
    ninja -C build
    sudo ninja -C build install
    cd ..
    rm -rf mako
  fi

  if ! command -v wlsunset &> /dev/null; then
    rm -rf wlsunset
    git clone https://github.com/kennylevinsen/wlsunset.git
    cd wlsunset
    meson build
    ninja -C build
    sudo ninja -C build install
    cd ..
    rm -rf wlsunset
  fi
}
