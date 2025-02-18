#!/bin/bash

# Detect if running on VirtualBox or a physical machine
VBOX=$(sudo dmidecode -s system-manufacturer)  # e.g., "LENOVO" for physical machine
VBOX1=$(sudo dmidecode -s bios-version)  # "VirtualBox" if running inside a VM

# Check if running in VirtualBox
if [[ "$VBOX1" == "VirtualBox" ]]; then
    echo "Running inside VirtualBox. Skipping installation."
    exit 0
else
    echo "Running on a physical machine. Proceeding with installation."
fi

# Update package list
echo "Updating package list..."
sudo apt-get update && sudo apt-get upgrade -y

# Add Oracle VirtualBox GPG key (alternative for apt-key deprecation)
echo "Adding Oracle VirtualBox GPG key..."
wget -qO- https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo tee /etc/apt/trusted.gpg.d/oracle_vbox_2016.asc > /dev/null

# Install prerequisites
echo "Installing required packages..."
wget http://ftp.us.debian.org/debian/pool/main/libv/libvpx/libvpx7_1.12.0-1+deb12u3_amd64.deb
sudo dpkg -i ./libvpx7_1.12.0-1+deb12u3_amd64.deb

# Install VirtualBox and dependencies
echo "Installing VirtualBox..."
sudo apt-get install -y virtualbox virtualbox-dkms virtualbox-ext-pack virtualbox-guest-utils virtualbox-qt virtualbox-guest-x11 linux-headers-$(uname -r)

# Add current user to vboxusers group
echo "Adding user to vboxusers group..."
sudo usermod -a -G vboxusers $USER

echo "VirtualBox installation completed!"

# Insurance
# sudo modprobe vboxnetflt

# Cross your fingers
