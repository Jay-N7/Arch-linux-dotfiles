#!/bin/bash

# Snapper config name
CONFIG="root"

# Number of snapshots to keep
KEEP=2

# List all snapshot numbers (excluding #0 "current") in reverse order
snapshots=$(snapper -c "$CONFIG" list | awk 'NR>1 && $1 != "#" {print $1}' | sort -rn)

# Skip the first $KEEP snapshots and delete the rest
count=0
for snap in $snapshots; do
    ((count++))
    if [ "$count" -le "$KEEP" ]; then
        continue
    fi
    echo "Deleting snapshot #$snap"
    snapper -c "$CONFIG" delete "$snap"
done
