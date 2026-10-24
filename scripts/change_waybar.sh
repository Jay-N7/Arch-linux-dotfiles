#!/bin/bash
set -e  # exit if any command fails

WAYBAR_DIR="$HOME/.config/waybar"

# Swap configs
mv "$WAYBAR_DIR/config.jsonc" "$WAYBAR_DIR/temp_config.jsonc"
mv "$WAYBAR_DIR/og_config.jsonc" "$WAYBAR_DIR/config.jsonc"
mv "$WAYBAR_DIR/temp_config.jsonc" "$WAYBAR_DIR/og_config.jsonc"

# Swap styles
mv "$WAYBAR_DIR/style.css" "$WAYBAR_DIR/temp_style.css"
mv "$WAYBAR_DIR/og_style.css" "$WAYBAR_DIR/style.css"
mv "$WAYBAR_DIR/temp_style.css" "$WAYBAR_DIR/og_style.css"

# Reload waybar
"$HOME/scripts/toggle-waybar.sh"
