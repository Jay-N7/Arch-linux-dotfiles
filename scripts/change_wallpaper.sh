#!/bin/bash

WALLPAPER_DIR="$HOME/Downloads/wallpapers"
CURRENT_WALL_FILE="$HOME/.current_wall"

# Get list of images
IMAGES=($(ls "$WALLPAPER_DIR" | grep -E '\.(jpg|jpeg|png|bmp|webp)$' | sort))

# Get current wallpaper
CURRENT=$(cat "$CURRENT_WALL_FILE" 2>/dev/null || echo "")

# Find next wallpaper
NEXT=""
FOUND=0
for img in "${IMAGES[@]}"; do
    if [ "$FOUND" = "1" ]; then
        NEXT="$img"
        break
    fi
    if [ "$img" = "$CURRENT" ]; then
        FOUND=1
    fi
done

# If no next found, cycle back to first
[ -z "$NEXT" ] && NEXT="${IMAGES[0]}"

# Save next wallpaper name
echo "$NEXT" > "$CURRENT_WALL_FILE"

# Set wallpaper using swww
awww img "$WALLPAPER_DIR/$NEXT"

# Reload pywal colors from the new wallpaper
#wal -i "$WALLPAPER_DIR/$NEXT"


