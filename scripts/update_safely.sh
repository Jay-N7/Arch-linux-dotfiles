#!/usr/bin/env bash

set -euo pipefail

SNAPSHOT_DIR="/.snapshots"
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
NEW_SNAPSHOT="${SNAPSHOT_DIR}/${TIMESTAMP}"

# Ensure running as root
if [[ $EUID -ne 0 ]]; then
    echo "Run as root."
    exit 1
fi

mkdir -p "$SNAPSHOT_DIR"

echo "Checking existing snapshots..."

# Get snapshots sorted oldest -> newest
mapfile -t snapshots < <(
    find "$SNAPSHOT_DIR" \
        -mindepth 1 \
        -maxdepth 1 \
        -type d \
        | sort
)

# Keep only 1 existing snapshot before creating a new one
# so that after creation there are exactly 2.
while (( ${#snapshots[@]} >= 2 )); do
    oldest="${snapshots[0]}"
    echo "Deleting oldest snapshot: $oldest"
    btrfs subvolume delete "$oldest"

    snapshots=("${snapshots[@]:1}")
done

echo "Creating snapshot: $NEW_SNAPSHOT"
btrfs subvolume snapshot -r / "$NEW_SNAPSHOT"

echo "Updating system..."
pacman -Syu

echo "Done."
