#!/bin/bash

# Internet Speed Optimization Script for Debian Linux
# Optimizes TCP/UDP buffer sizes and network parameters
# Run with: sudo ./kali-internet-optimizer.sh
# Nov 30, 2025

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}Please run as root (use sudo)${NC}"
    exit 1
fi

echo -e "${GREEN}=== Internet Speed Optimization Script ===${NC}\n"

# Backup current settings
BACKUP_DIR="/root/network-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo -e "${YELLOW}Creating backup of current settings...${NC}"
sysctl -a | grep -E 'net\.(core|ipv4)' > "$BACKUP_DIR/sysctl-backup.txt" 2>/dev/null
if [ -f /etc/sysctl.conf ]; then
    cp /etc/sysctl.conf "$BACKUP_DIR/sysctl.conf.backup"
fi
echo -e "${GREEN}Backup saved to: $BACKUP_DIR${NC}\n"

# Function to show current values
show_current_values() {
    echo -e "${YELLOW}Current TCP Buffer Settings:${NC}"
    echo "TCP rmem (read): $(sysctl net.ipv4.tcp_rmem | cut -d= -f2)"
    echo "TCP wmem (write): $(sysctl net.ipv4.tcp_wmem | cut -d= -f2)"
    echo "Core rmem_max: $(sysctl net.core.rmem_max | cut -d= -f2)"
    echo "Core wmem_max: $(sysctl net.core.wmem_max | cut -d= -f2)"
    echo ""
}

echo -e "${YELLOW}=== BEFORE OPTIMIZATION ===${NC}"
show_current_values

# Apply optimizations
echo -e "${YELLOW}Applying TCP/UDP optimizations...${NC}\n"

# Create or append to sysctl.conf
SYSCTL_CONF="/etc/sysctl.d/99-network-optimization.conf"

cat > "$SYSCTL_CONF" << 'EOF'
# Network Optimization Settings
# Applied by internet-speed-upgrade.sh

# Increase TCP buffer sizes (min/default/max in bytes)
# These values work well for high-speed connections
net.core.rmem_max = 134217728
net.core.wmem_max = 134217728
net.core.rmem_default = 16777216
net.core.wmem_default = 16777216

# TCP memory tuning (pages, not bytes)
# min/default/max
net.ipv4.tcp_rmem = 4096 87380 67108864
net.ipv4.tcp_wmem = 4096 65536 67108864

# UDP buffer sizes
net.ipv4.udp_rmem_min = 8192
net.ipv4.udp_wmem_min = 8192

# Increase network device backlog
net.core.netdev_max_backlog = 5000

# TCP tuning for better performance
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_timestamps = 1
net.ipv4.tcp_sack = 1
net.ipv4.tcp_no_metrics_save = 1

# Enable TCP Fast Open (reduces latency)
net.ipv4.tcp_fastopen = 3

# Congestion control algorithm (BBR is excellent for throughput)
# Falls back to cubic if BBR not available
net.ipv4.tcp_congestion_control = bbr
net.core.default_qdisc = fq

# Increase connection tracking
net.netfilter.nf_conntrack_max = 262144

# Reduce TIME_WAIT connections
net.ipv4.tcp_fin_timeout = 15
net.ipv4.tcp_tw_reuse = 1

# Increase local port range
net.ipv4.ip_local_port_range = 1024 65535

# Enable MTU probing (helps find optimal packet size)
net.ipv4.tcp_mtu_probing = 1
EOF

echo -e "${GREEN}Configuration written to: $SYSCTL_CONF${NC}\n"

# Load BBR module if available
echo -e "${YELLOW}Checking for BBR congestion control...${NC}"
if modprobe tcp_bbr 2>/dev/null; then
    echo -e "${GREEN}BBR module loaded successfully${NC}"
else
    echo -e "${YELLOW}BBR not available, will use cubic (still good)${NC}"
    sed -i 's/net.ipv4.tcp_congestion_control = bbr/net.ipv4.tcp_congestion_control = cubic/' "$SYSCTL_CONF"
fi
echo ""

# Apply settings immediately
echo -e "${YELLOW}Applying settings...${NC}"
sysctl -p "$SYSCTL_CONF"
echo ""

echo -e "${YELLOW}=== AFTER OPTIMIZATION ===${NC}"
show_current_values

# Benchmark instructions
cat << 'EOF'

╔════════════════════════════════════════════════════════════════╗
║                    OPTIMIZATION COMPLETE!                       ║
╚════════════════════════════════════════════════════════════════╝

Your network parameters have been optimized for high-speed connections.
Changes are applied immediately and will persist after reboot.

📊 BENCHMARK YOUR CONNECTION:

1. Simple speed test:
   sudo apt install speedtest-cli
   speedtest-cli

2. Accurate TCP throughput (recommended):
   sudo apt install iperf3
   iperf3 -c speedtest.uztelecom.uz -P 4
   # Or try: iperf3 -c ping.online.net -P 4

3. Download test:
   wget -O /dev/null http://speedtest.tele2.net/100MB.zip

4. Multiple parallel connections (shows improvement best):
   aria2c -x 16 -s 16 http://speedtest.tele2.net/100MB.zip

💡 TIPS:
- Test at different times of day
- Improvements are most noticeable on high-speed (100+ Mbps) connections
- For gigabit connections, you may see 2-3x speed improvements
- Try download managers that support multiple connections (aria2c, axel)

🔄 TO RESTORE ORIGINAL SETTINGS:
   sudo sysctl -p $BACKUP_DIR/sysctl.conf.backup
   sudo rm $SYSCTL_CONF

📁 Backup location: $BACKUP_DIR

EOF

echo -e "${GREEN}Done! Reboot not required - changes active now.${NC}"
