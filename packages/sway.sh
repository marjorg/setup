#!/bin/bash

install() {
  if [[ "$IS_LINUX" == "true" ]]; then
    install_apt sway
    install_apt swaylock
    install_apt swayidle

    # When updating to Ubuntu 23+ this (deps below, +wayland-protocols & mako) can be replaced by install_apt sway-notification-center
    install_apt meson
    install_apt libwayland-dev
    install_apt libpango1.0-dev
    install_apt libcairo2-dev
    install_apt libsystemd-dev
    install_apt libgdk-pixbuf2.0-dev
    install_apt libdbus-1-dev

    execute rm -rf wayland-protocols-1.32.tar.xz wayland-protocols-1.32
    execute wget https://gitlab.freedesktop.org/wayland/wayland-protocols/-/releases/1.32/downloads/wayland-protocols-1.32.tar.xz
    execute tar -xf wayland-protocols-1.32.tar.xz
    execute cd wayland-protocols-1.32
    execute meson setup build --prefix=/usr --buildtype=release
    execute ninja -C build
    execute sudo ninja -C build install
    execute cd ..
    execute rm -rf wayland-protocols-1.32.tar.xz wayland-protocols-1.32

    if ! command -v mako &> /dev/null; then
      execute rm -rf mako
      execute git clone https://github.com/emersion/mako.git
      execute cd mako
      execute meson build
      execute ninja -C build
      execute sudo ninja -C build install
      execute cd ..
      execute rm -rf mako
    fi

    if ! command -v wlsunset &> /dev/null; then
      execute rm -rf wlsunset
      execute git clone https://github.com/kennylevinsen/wlsunset.git
      execute cd wlsunset
      execute meson build
      execute ninja -C build
      execute sudo ninja -C build install
      execute cd ..
      execute rm -rf wlsunset
    fi
  fi
}
