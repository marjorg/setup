#!/bin/bash

# File with apps or paths on separate lines
FILE="$HOME/.config/i3/startup-apps.txt"

if [ -f "$FILE" ]; then
  while IFS= read -r line; do
    # Skip empty lines and comments (lines starting with #)
    [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue

    # Trim whitespace
    app=$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

    if [[ -n "$app" ]]; then
      "$app"
    fi
  done < "$FILE"
fi
