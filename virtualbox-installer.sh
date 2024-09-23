#!/bin/bash

# Add Oracle VirtualBox GPG key
echo "Adding Oracle VirtualBox GPG key..."
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -

# Update package list
echo "Updating package list..."
sudo apt-get update && apt-get upgrade -y

# Install prerequisites
echo "Installing required packages..."
wget http://ftp.us.debian.org/debian/pool/main/libv/libvpx/libvpx7_1.12.0-1+deb12u3_amd64.deb
dpkg -i ./libvpx7_1.12.0-1+deb12u3_amd64.deb

sudo apt-get install -y wget apt-transport-https software-properties-common
sudo apt-get install -y virtualbox virtualbox-dkms virtualbox-ext-pack virtualbox-guest-utils virtualbox-qt virtualbox-guest-x11

echo "VirtualBox installation completed!"
sudo usermod -a -G vboxusers $USER
