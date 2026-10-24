#!/bin/bash

INTERNAL="eDP-1"

# check if monitor is currently active (DPMS hack: infer via power state)
if hyprctl monitors | grep -q "$INTERNAL"; then

    # check if screen is currently ON using brightness query fallback
    BRIGHTNESS=$(hyprctl monitors | awk -v m="$INTERNAL" '
        $0 ~ m {found=1}
        found && /active/ {print $2; exit}
    ')

    # simpler + reliable toggle: just query dpms via hyprctl dispatch state
    if hyprctl monitors | grep -A5 "$INTERNAL" | grep -q "disabled: true"; then
        hl.monitor({ output = "eDP-1", disabled = false })
        notify-send "Hyprland" "Laptop monitor enabled"
    else
        hl.monitor({ output = "eDP-1", disabled = true })
        notify-send "Hyprland" "Laptop monitor disabled"
    fi

fi
