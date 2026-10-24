#!/bin/bash

# Mount point for USB
DEST=/mnt/usb/minimal_backup

echo "📁 Creating backup folder..."
mkdir -p "$DEST"

echo "🔁 Backing up system config and critical dirs..."
rsync -aAXv \
  --exclude={"/dev","/proc","/sys","/tmp","/run","/mnt","/media","/lost+found","/home"} \
  /etc /boot /root /usr/lib/modules /usr/share/mkinitcpio /var/lib/systemd "$DEST"

echo "🧾 Saving package list..."
pacman -Qqe > "$DEST/pkglist.txt"

echo "🗂️ Backing up user config (~/.config)..."
mkdir -p "$DEST/user_config"
rsync -aAXv /home/"$SUDO_USER"/.config "$DEST/user_config"

echo "✅ Backup complete!"
