#!/bin/bash

# Toggle floating
hyprctl dispatch togglefloating

# Wait until the window is floating
for i in {1..10}; do
  sleep 0.05
  if hyprctl activewindow -j | grep '"floating": true' >/dev/null; then
    break
  fi
done

# Get monitor dimensions
read SCREEN_WIDTH SCREEN_HEIGHT <<< $(hyprctl monitors -j | jq -r '.[0].width, .[0].height')

# Calculate 75% size
WIDTH=$(echo "$SCREEN_WIDTH * 0.75" | bc | cut -d'.' -f1)
HEIGHT=$(echo "$SCREEN_HEIGHT * 0.75" | bc | cut -d'.' -f1)

# Resize and center
hyprctl dispatch resizeactive exact $WIDTH $HEIGHT
hyprctl dispatch centerwindow

