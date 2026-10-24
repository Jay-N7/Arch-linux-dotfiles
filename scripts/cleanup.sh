#!/bin/bash

# Arch Linux Cleanup Script

echo "==> Cleaning old package versions (keeping current + 1 previous)..."
sudo paccache -r -k 2

echo
echo "==> Listing orphaned packages..."
orphans=$(pacman -Qdtq)

if [ -z "$orphans" ]; then
    echo "✅ No orphaned packages found."
else
    echo "Found orphans:"
    pacman -Qdt

    echo
    read -p "Do you want to remove these orphaned packages? [y/N]: " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        sudo pacman -Rns $orphans
    else
        echo "❎ Skipping orphan removal."
    fi
fi

echo
echo "==> Cleaning yay AUR cache..."
read -p "Clean AUR cache with yay -Sc (keep installed packages)? [y/N]: " confirm_yay
if [[ "$confirm_yay" =~ ^[Yy]$ ]]; then
    yay -Sc
else
    echo "❎ Skipping yay cache clean."
fi

echo
echo "✅ Done!"

