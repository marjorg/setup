#!/bin/bash

BG_IMG="$("$HOME/.config/sway/get-bg.sh")"

i3lock \
  --image="$BG_IMG" \
  --fill \
  --clock \
  --radius=130 \
  --ring-width=7 \
  --ring-color=7aa2f7 \
  --keyhl-color=7aa2f7 \
  --bshl-color=f7768e \
  --ringver-color=9ece6a \
  --ringwrong-color=f7768e \
  --inside-color=1a1b2688 \
  --insidever-color=1a1b2688 \
  --insidewrong-color=1a1b2688 \
  --line-color=00000000 \
  --separator-color=414868 \
  --verif-color=c0caf5 \
  --wrong-color=c0caf5 \
  --time-color=c0caf5 \
  --date-color=c0caf5 \
  --layout-color=c0caf5 \
  --greeter-color=c0caf5
