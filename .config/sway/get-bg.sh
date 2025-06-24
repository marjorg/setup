#!/bin/bash

if [[ -f "$HOME/bg.png" ]]; then
  echo "$HOME/bg.png"
else
  echo "$HOME/.config/sway/bg-2.png"
fi
