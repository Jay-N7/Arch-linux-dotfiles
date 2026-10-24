#!/bin/sh
# rofi script mode: Hyprland window switcher (rofi 2.0.0's built-in Wayland
# window mode ignores Alt+N and closes rofi).
#   Enter -> focus window   Shift+Del -> close window
addr() { printf 'hl.dsp.%s({ window = "address:%s" })' "$1" "$ROFI_INFO"; }

case "$ROFI_RETV" in
    1)  hyprctl dispatch "$(addr focus)" >/dev/null 2>&1
        exit 0 ;;
    3)  hyprctl dispatch "$(addr window.close)" >/dev/null 2>&1
        sleep 0.15 ;;
esac

printf '\000no-custom\037true\n'
hyprctl clients -j | jq -r '
  map(select(.mapped and (.hidden | not) and .focusHistoryID != 0))
  | sort_by(.focusHistoryID)[]
  | "\(.class)  \(.title | gsub("[\n\u0000\u001f]"; " "))\u0000icon\u001f\(.class | ascii_downcase)\u001finfo\u001f\(.address)\u001fmeta\u001fworkspace \(.workspace.name)"'
