#!/bin/sh
# rofi script mode: dictionary. Type a word, press Enter.
# Kept as sh so rofi's startup never pays for a python launch;
# python only runs once you actually look something up.
if [ "${ROFI_RETV:-0}" = 0 ]; then
    printf '\000message\037Type a word and press Enter\n'
    exit 0
fi
exec python3 "$(dirname "$0")/dict.py" "$@"
