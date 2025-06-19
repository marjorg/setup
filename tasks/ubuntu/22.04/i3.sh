#!/bin/bash

install() {
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
    redshift

    # sudo systemctl enable lightdm
    # sudo systemctl start lightdm
}
