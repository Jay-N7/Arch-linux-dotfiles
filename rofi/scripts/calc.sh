#!/bin/sh
# Fallback calculator (only used when the rofi-calc plugin isn't installed).
if [ "${ROFI_RETV:-0}" = 0 ]; then
    exit 0
fi
exec python3 "$(dirname "$0")/calc.py" "$@"
