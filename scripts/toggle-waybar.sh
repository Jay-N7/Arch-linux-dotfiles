#!/usr/bin/env bash

# — Absolute path to Waybar binary
WAYBAR_BIN="$(command -v waybar)"

# Helper: extract the wallpaper path from swww
get_current_wallpaper() {
  swww query | sed -n 's/.*currently displaying: image: //p'
}

# If Waybar is running, kill it and exit (toggle off)
if pgrep -x waybar >/dev/null; then
  pkill -x waybar
  exit 0
fi

# Otherwise, find wallpaper & regenerate pywal
#wallpaper="$(get_current_wallpaper)"
#if [ -z "$wallpaper" ] || [ ! -f "$wallpaper" ]; then
#  echo "Error: no wallpaper found: $wallpaper" >&2
#  exit 1
#fi
#
#wal -i "$wallpaper"|| { echo "Error: wal failed" >&2; exit 1; }
#if [ -f ~/.config/wal/templates/colors-waybar.css ]; then
#  cat ~/.config/wal/templates/colors-waybar.css \
#    >> ~/.cache/wal/colors-waybar.css
#fi

# ── NEW LAUNCH METHOD ──
# Use setsid to detach and redirect stdout/stderr to a logfile so we can debug
LOG="$HOME/.cache/waybar-launch.log"
setsid "$WAYBAR_BIN" >>"$LOG" 2>&1 &
disown

# (Optional) print for your terminal so you know it ran
echo "Waybar launched (logs -> $LOG)"
