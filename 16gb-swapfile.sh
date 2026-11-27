#!/usr/bin/env bash
# Add a 16 GiB swapfile; with the reported ~976 MiB existing swap this gives ~17 GiB total.
# Existing swap is preserved. Supports ext4/xfs and Btrfs.
# Run as root: sudo bash ./add-16g-swap.sh

set -Eeuo pipefail

SWAPFILE="/swapfile"
SWAP_SIZE="16G"
SWAP_BYTES=$((16 * 1024 * 1024 * 1024))
FSTAB="/etc/fstab"

fail() { echo "ERROR: $*" >&2; exit 1; }

[[ $EUID -eq 0 ]] || fail "Run as root: sudo bash $0"
command -v swapon >/dev/null || fail "swapon not found (install util-linux)."
command -v mkswap >/dev/null || fail "mkswap not found (install util-linux)."
[[ -f "$FSTAB" ]] || fail "$FSTAB not found."

echo "=== Existing swap ==="
swapon --show || true
echo
echo "=== Root filesystem ==="
ROOT_FS="$(findmnt -n -o FSTYPE /)"
echo "Filesystem: $ROOT_FS"

# Do not overwrite or silently reuse an existing file.
if [[ -e "$SWAPFILE" ]]; then
    fail "$SWAPFILE already exists. Nothing changed. Inspect it with: ls -lh $SWAPFILE; file $SWAPFILE; swapon --show"
fi

# Ensure enough free space for the swapfile plus a small safety margin.
AVAIL_BYTES="$(df -B1 --output=avail / | tail -n 1 | tr -d ' ')"
REQUIRED_BYTES=$((SWAP_BYTES + 1 * 1024 * 1024 * 1024))
(( AVAIL_BYTES >= REQUIRED_BYTES )) || fail "Need at least 17 GiB free on /. Available: $(numfmt --to=iec "$AVAIL_BYTES")."

# Refuse if fstab already contains a swapfile entry at this path.
if grep -Eq '^[[:space:]]*/swapfile[[:space:]]' "$FSTAB"; then
    fail "$FSTAB already contains an /swapfile entry. Nothing changed."
fi

cleanup() {
    if [[ -e "$SWAPFILE" ]] && ! swapon --noheadings --show=NAME | grep -Fxq "$SWAPFILE"; then
        rm -f "$SWAPFILE"
    fi
}
trap cleanup ERR

echo
echo "=== Creating $SWAP_SIZE swapfile ==="
case "$ROOT_FS" in
    btrfs)
        command -v btrfs >/dev/null || fail "Btrfs detected but btrfs-progs is not installed."
        btrfs filesystem mkswapfile --size "$SWAP_SIZE" "$SWAPFILE"
        ;;
    *)
        if command -v fallocate >/dev/null && fallocate -l "$SWAP_SIZE" "$SWAPFILE" 2>/dev/null; then
            :
        else
            rm -f "$SWAPFILE"
            echo "fallocate unavailable/unsupported; creating swapfile with dd (this may take a while)..."
            dd if=/dev/zero of="$SWAPFILE" bs=1M count=16384 status=progress conv=fsync
        fi
        chmod 600 "$SWAPFILE"
        mkswap "$SWAPFILE"
        ;;
esac

chmod 600 "$SWAPFILE"
swapon "$SWAPFILE"

# Persist across reboot. Keep all pre-existing swap entries unchanged.
printf '\n%s none swap sw 0 0\n' "$SWAPFILE" >> "$FSTAB"

trap - ERR

echo
echo "=== Swap after change ==="
swapon --show
free -h
echo
echo "SUCCESS: Added a 16 GiB swapfile at $SWAPFILE and enabled it at boot."
echo "Existing swap was left enabled and unchanged."
echo "With your reported ~976 MiB existing swap, total swap is now approximately 17 GiB. This adds memory headroom; it does not make model inference faster."
