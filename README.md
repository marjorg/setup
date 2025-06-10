# Dotfiles & Setup

1. [Mac Only] Log with Apple ID to enable installation of Mac App Store apps via CLI.
2. `/bin/bash -c "$(wget -qO- https://raw.githubusercontent.com/marjorg/setup/main/setup.sh)"`

<!--
  Driver stuff:

  Switch to Nouveau:
  ```
    Alt 1:
    sudo apt purge nvidia-*
    sudo apt install xserver-xorg-video-nouveau
    sudo reboot

    Alt 2:
    export WLR_NO_HARDWARE_CURSORS=1
    export __GLX_VENDOR_LIBRARY_NAME=nvidia

    Alt 3:
    sudo apt install libgbm1
    export WLR_NO_HARDWARE_CURSORS=1
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export GBM_BACKEND=nvidia-drm
  ```

  Try to fix multi display:
  ```
    See if nov:
    lsmod | grep nouveau
    See current outputs:
    xrandr or swaymsg -t get_outputs
    Enable outputs:
    xrandr --output HDMI-1 --auto --right-of eDP-1 (replace with actual names)
    Try with kernel params:
    sudo nano /etc/default/grub
    GRUB_CMDLINE_LINUX_DEFAULT="quiet splash" -> "quiet splash nouveau.modeset=1"
    sudo update-grub
    sudo reboot
    Sway to move:
    swaymsg output HDMI-A-1 enable position 1920 0

-->
