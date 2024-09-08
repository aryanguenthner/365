# 09/08/2024
# Make Kali Fast Again
# Enable TCP BBR (Bottleneck Bandwidth and RTT)
# BBR is a congestion control algorithm developed by Google that can increase throughput on TCP connections.
sudo sysctl net.ipv4.tcp_congestion_control=bbr
sudo sysctl net.core.default_qdisc=fq

# Add to /etc/sysctl.conf to make it persistent:
echo "Making TCP BBR and FQ persistent across reboots..."
echo "Making TCP BBR and FQ persistent across reboots" >> /etc/sysctl.conf
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
echo

# Optimize TCP Settings
echo "Optimize TCP Settings persistent across reboots..."
echo "net.ipv4.tcp_window_scaling = 1" >> /etc/sysctl.conf
echo "net.ipv4.tcp_moderate_rcvbuf = 1" >> /etc/sysctl.conf
echo "net.core.rmem_max = 16777216" >> /etc/sysctl.conf
echo "net.core.wmem_max = 16777216" >> /etc/sysctl.conf
echo "net.ipv4.tcp_rmem = 4096 87380 16777216" >> /etc/sysctl.conf
echo "net.ipv4.tcp_wmem = 4096 65536 16777216" >> /etc/sysctl.conf

# Then, apply the changes:
sudo sysctl -p
