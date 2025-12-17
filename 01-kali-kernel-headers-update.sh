#!/usr/bin/env bash
set -euo pipefail

echo "=== Installing Kernel Headers ==="

KERNEL="$(uname -r)"

echo "Running kernel: $KERNEL"

sudo apt install -y "linux-headers-$KERNEL"

echo -e "\033[1;32m[✓] Kernel headers installed for $KERNEL\033[0m"

