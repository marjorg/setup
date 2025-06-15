#!/bin/bash

install() {
  # Temporarily using i3 instead of sway because I have nvidia :(
  sudo pacman -Sy --noconfirm --needed xorg \
    xorg-xinit \
    i3-wm \
    i3status \
    i3lock \
    dmenu \
    lightdm \
    lightdm-gtk-greeter

  # sudo systemctl enable lightdm
  # sudo systemctl start lightdm
}
