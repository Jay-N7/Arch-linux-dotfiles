#!/usr/bin/env bash
# battery-watch.sh — send one-time critical notifications at 20%↓ and 90%↑

LOW_WARNED=false
HIGH_WARNED=false

while true; do
  # Modern battery query (works on both X11 and Wayland)
  if ! BATTERY_INFO=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 2>/dev/null); then
    sleep 60
    continue
  fi

  PERCENT=$(echo "$BATTERY_INFO" | grep percentage | awk '{print $2}' | tr -d '%')
  STATE=$(echo "$BATTERY_INFO" | grep state | awk '{print $2}')

  # Send low‐battery warning at ≤20% on discharge
  if [[ $STATE == "discharging" ]] && (( PERCENT <= 20 )) && [[ $LOW_WARNED == false ]]; then
    notify-send -u critical -t 0 \
      "Battery Low: ${PERCENT}% remaining" \
      "Please plug in the charger—system will auto‐sleep soon." \
      -i battery-low
    LOW_WARNED=true
    HIGH_WARNED=false
  fi

  # Send high‐battery warning at ≥90% on charge
  if [[ $STATE == "charging" ]] && (( PERCENT >= 90 )) && [[ $HIGH_WARNED == false ]]; then
    notify-send -u critical -t 0 \
      "Battery High: ${PERCENT}% reached" \
      "Consider unplugging charger to preserve battery health." \
      -i battery-full
    HIGH_WARNED=true
    LOW_WARNED=false
  fi

  sleep 60
done
