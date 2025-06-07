IS_MAC=$(uname -s | grep -q Darwin && echo true || echo false)
IS_LINUX=$(uname -s | grep -q Linux && echo true || echo false)

if [[ -z "$DISPLAY" ]] && [[ "$(tty)" == "/dev/tty1" ]] && [[ "$IS_LINUX" == true ]]; then
  exec sway
fi
