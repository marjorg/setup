#!/bin/bash

BG_IMG="$("$HOME/.config/sway/get-bg.sh")"

swaylock \
  -i $BG_IMG \
  --font "Noto Sans" \
  --font-size 16 \
  --indicator-radius 130 \
  --indicator-thickness 7 \
  --ring-color 7aa2f7 \
  --key-hl-color 7aa2f7 \
  --bs-hl-color f7768e \
  --ring-ver-color 9ece6a \
  --ring-wrong-color f7768e \
  --inside-color 1a1b2688 \
  --inside-ver-color 1a1b2688 \
  --inside-wrong-color 1a1b2688 \
  --line-color 00000000 \
  --line-ver-color 00000000 \
  --line-wrong-color 00000000 \
  --separator-color 414868 \
  --text-color c0caf5 \
  --text-ver-color c0caf5 \
  --text-wrong-color c0caf5
