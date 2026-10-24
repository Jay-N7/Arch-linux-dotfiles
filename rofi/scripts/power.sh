#!/bin/sh
# rofi script mode: TLP power profiles (power-saver / balanced / performance)
# Uses tlpctl (TLP >= 1.9, needs tlp-pd running, no root needed).
# Falls back to powerprofilesctl, then to `pkexec tlp <profile>`.

if command -v tlpctl >/dev/null 2>&1; then
    get() { tlpctl get 2>/dev/null; }
    put() { tlpctl set "$1"; }
elif command -v powerprofilesctl >/dev/null 2>&1; then
    get() { powerprofilesctl get 2>/dev/null; }
    put() { powerprofilesctl set "$1"; }
else
    get() { :; }
    put() { pkexec tlp "$1"; }
fi

if [ "$ROFI_RETV" = 1 ]; then
    put "$ROFI_INFO" >/dev/null 2>&1 &&
        command -v notify-send >/dev/null && notify-send -t 1500 "Power profile" "$ROFI_INFO"
    exit 0
fi

cur=$(get | tr -d '[:space:]')
printf '\000no-custom\037true\n'
printf '\000message\037Current: %s\n' "${cur:-unknown}"

i=0
for p in power-saver balanced performance; do
    [ "$p" = "$cur" ] && printf '\000active\037%d\n' "$i"
    i=$((i + 1))
done
printf 'Power saver\000info\037power-saver\037icon\037power-profile-power-saver-symbolic\n'
printf 'Balanced\000info\037balanced\037icon\037power-profile-balanced-symbolic\n'
printf 'Performance\000info\037performance\037icon\037power-profile-performance-symbolic\n'
