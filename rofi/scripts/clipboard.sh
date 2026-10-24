#!/bin/sh
# rofi script mode: cliphist history
#   Enter      -> copy entry back to the clipboard
#   Shift+Del  -> delete entry from history (stays open)
# ROFI_INFO carries the raw cliphist line ("<id>\t<preview>") for each row.

case "$ROFI_RETV" in
    1)  # selected: decode + copy; detach wl-copy from rofi's pipe or rofi hangs
        printf '%s' "$ROFI_INFO" | cliphist decode | wl-copy >/dev/null 2>&1
        exit 0 ;;
    3)  # Shift+Delete
        printf '%s' "$ROFI_INFO" | cliphist delete ;;
esac

printf '\000no-custom\037true\n'
# show the preview without the numeric id; keep the full line in "info"
cliphist list | awk '{
    i = index($0, "\t")
    printf "%s%c%s%c%s\n", substr($0, i + 1), 0, "info", 31, $0
}'
