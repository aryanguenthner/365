#!/usr/bin/env bash
set -euo pipefail

echo "=== Kali System & Kernel Upgrade ==="

sudo apt update
echo
echo "Please reboot after this update"
echo
sudo apt full-upgrade -y && reboot

# Detect kernel upgrade
if apt list --upgradable 2>/dev/null | grep -q linux-image; then
    echo
    echo -e "\033[1;33m[!] Kernel was upgraded. Reboot REQUIRED before continuing.\033[0m"
    echo
    read -rp "Reboot now? [Y/n]: " ans
    ans=${ans:-Y}
    if [[ "$ans" =~ ^[Yy]$ ]]; then
        sudo reboot
    else
        echo "Please reboot manually before running 01-kernel-headers.sh"
        exit 0
    fi
else
    echo -e "\033[1;32m[✓] No kernel upgrade detected\033[0m"
fi
