#!/bin/sh
# waybar custom/updates: pending pacman (+AUR) updates. Empty output hides the module.
# Needs pacman-contrib (checkupdates). AUR counted if yay or paru is installed.
repo=$(checkupdates 2>/dev/null | wc -l)
aur=0
if command -v yay >/dev/null 2>&1; then aur=$(yay -Qua 2>/dev/null | wc -l)
elif command -v paru >/dev/null 2>&1; then aur=$(paru -Qua 2>/dev/null | wc -l); fi
total=$((repo + aur))
[ "$total" -eq 0 ] && { echo '{"text": ""}'; exit 0; }
printf '{"text": "%s", "tooltip": "%s official, %s AUR", "class": "pending"}\n' "$total" "$repo" "$aur"
