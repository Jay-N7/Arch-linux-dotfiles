#!/bin/bash
# update_arch_repo.sh — one script for both backups.
#
#   update_arch_repo.sh          dotfiles -> GitHub (configs, scripts, package lists)
#   update_arch_repo.sh --usb    the above, then a system backup to the USB drive
#
# Run as your normal user (not with sudo). The USB part asks for your password itself.

set -e

USB_MOUNT=/mnt/usb
USB_DEST="$USB_MOUNT/minimal_backup"

DO_USB=false
case "$1" in
    "")       ;;
    --usb)    DO_USB=true ;;
    *)        echo "usage: $(basename "$0") [--usb]"; exit 1 ;;
esac

[ "$EUID" -eq 0 ] && { echo "Run this as your normal user, not with sudo."; exit 1; }

# check the USB drive up front, so we don't push to GitHub and then fail
if $DO_USB && ! mountpoint -q "$USB_MOUNT"; then
    echo "Nothing is mounted at $USB_MOUNT. Mount the drive first, e.g.:"
    echo "  sudo mount /dev/sdX1 $USB_MOUNT      (find sdX1 with: lsblk)"
    exit 1
fi

echo "==> Dotfiles"

DOTFILES="$HOME/Desktop/arch_dotfiles"

# ---- config folders (~/.config/<name>  ->  $DOTFILES/<name>) ----
CONFIG_DIRS=(
    hypr        # hyprland.lua, hypridle, hyprlock
    kitty
    nvim
    waybar
    wlogout
    rofi        # replaces wofi: config, theme, spotlight launcher + mode scripts
    swaync
    fastfetch
)

# ---- single files (path relative to $HOME  ->  same name in $DOTFILES) ----
FILES=(
    .config/starship.toml
    .bashrc
)

# ---- other folders (path relative to $HOME  ->  $DOTFILES/<last part>) ----
EXTRA_DIRS=(
    scripts     # ~/scripts: battery-watch, wallpaper, waybar toggles, this script
)

# never copy these into the repo
EXCLUDES=(--exclude '*.bak' --exclude '*.bak-*' --exclude '.git' --exclude '__pycache__')

[ -d "$DOTFILES/.git" ] || { echo "No git repo at $DOTFILES — clone it first."; exit 1; }

for d in "${CONFIG_DIRS[@]}"; do
    if [ -d "$HOME/.config/$d" ]; then
        rsync -a --delete "${EXCLUDES[@]}" "$HOME/.config/$d/" "$DOTFILES/$d/"
    else
        echo "skip: ~/.config/$d (not found)"
    fi
done

for d in "${EXTRA_DIRS[@]}"; do
    if [ -d "$HOME/$d" ]; then
        rsync -a --delete "${EXCLUDES[@]}" "$HOME/$d/" "$DOTFILES/$(basename "$d")/"
    else
        echo "skip: ~/$d (not found)"
    fi
done

for f in "${FILES[@]}"; do
    if [ -f "$HOME/$f" ]; then
        cp "$HOME/$f" "$DOTFILES/"
    else
        echo "skip: ~/$f (not found)"
    fi
done

# ---- package lists ----
# full lists (same as before)
pacman -Q > "$DOTFILES/pacman_packages.txt"
command -v yay >/dev/null && yay -Q > "$DOTFILES/yay_packages.txt"
# reinstall-ready lists: only what you installed yourself, names only
pacman -Qqen > "$DOTFILES/pkglist_repo.txt" || true   # official repos
pacman -Qqem > "$DOTFILES/pkglist_aur.txt" || true    # AUR / foreign

# ---- commit and push ----
cd "$DOTFILES"
git add -A

if ! git diff --cached --quiet; then
    git commit -m "Dotfiles $(date '+%Y-%m-%d %H:%M')"
    git push
else
    echo "No changes to commit."
fi

# =====================================================================
# System backup to USB (only with --usb)
# =====================================================================
$DO_USB || exit 0

echo
echo "==> System backup to $USB_DEST"
sudo mkdir -p "$USB_DEST"

echo "System config and critical dirs..."
sudo rsync -aAX --info=progress2 \
    /etc /boot /root /usr/lib/modules /usr/share/mkinitcpio /var/lib/systemd "$USB_DEST"

echo "Package list..."
pacman -Qqe | sudo tee "$USB_DEST/pkglist.txt" >/dev/null

echo "User config (~/.config)..."
sudo mkdir -p "$USB_DEST/user_config"
sudo rsync -aAX --info=progress2 "$HOME/.config" "$USB_DEST/user_config"

sync
echo "Done. Safe to unmount: sudo umount $USB_MOUNT"
