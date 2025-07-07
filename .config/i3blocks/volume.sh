#!/bin/bash

volume=$(pamixer --get-volume)
muted=$(pamixer --get-mute)

if [ "$muted" = "true" ]; then
    icon=""
    echo "$icon"
else
    if [ "$volume" -le 33 ]; then
        icon=""
    elif [ "$volume" -le 66 ]; then
        icon=""
    else
        icon=""
    fi
    echo "$icon   $volume%"
fi
