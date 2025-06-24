#!/bin/bash

install() {
  sudo add-apt-repository ppa:papirus/papirus -y
  sudo apt-get update

  sudo apt-get install -y \
    xorg \
    xinit \
    i3 \
    i3status \
    i3blocks \
    i3lock \
    dmenu \
    lightdm \
    lightdm-gtk-greeter \
    feh \
    rofi \
    lxappearance \
    sassc \
    gtk2-engines-murrine \
    gnome-themes-extra \
    papirus-icon-theme \
    pamixer

    # sudo systemctl enable lightdm
    # sudo systemctl start lightdm
}

# redshift
# sway
# swaylock
# swayidle
# wofi
# waybar
# meson
# libwayland-dev
# libpango1.0-dev
# libcairo2-dev
# libsystemd-dev
# libgdk-pixbuf2.0-dev
# libdbus-1-dev
# wayland-protocols
# mako
# wlsunset
