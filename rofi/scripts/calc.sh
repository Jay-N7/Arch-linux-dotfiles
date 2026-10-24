#!/bin/sh
# Fallback calculator (only used when the rofi-calc plugin isn't installed).
if [ "${ROFI_RETV:-0}" = 0 ]; then
    printf '\000message\037Type an expression and press Enter  (e.g. 2^10, sqrt(2)*pi, 15%% of 80)\n'
    exit 0
fi
exec python3 "$(dirname "$0")/calc.py" "$@"
