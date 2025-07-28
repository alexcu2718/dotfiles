#!/bin/bash

# Get current layout
current_layout=$(setxkbmap -query | awk '/layout:/ {print $2}')

# Toggle between 'us' and 'gb'
if [[ "$current_layout" == "us" ]]; then
    setxkbmap gb
    echo "Switched to UK (gb) layout"
else
    setxkbmap us
    echo "Switched to US (us) layout"
fi
