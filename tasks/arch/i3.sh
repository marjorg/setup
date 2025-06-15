#!/bin/bash

install() {
  # Temporarily using i3 instead of sway because I have nvidia :(
  sudo pacman -Sy --noconfirm --needed xorg \
    xorg-xinit \
    i3-wm \
    i3status \
    i3blocks \
    dmenu \
    lightdm \
    lightdm-gtk-greeter \
    feh \
    rofi \
    redshift \
    lxappearance \
    sassc \
    gnome-themes-extra

  yay -Sy --noconfirm --needed i3lock-color gtk-engine-murrine papirus-icon-theme

  # sudo systemctl enable lightdm
  # sudo systemctl start lightdm
}
