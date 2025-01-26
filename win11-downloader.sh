#!/bin/bash

# Define the download directory
DOWNLOAD_DIR="/home/kali/Downloads"
mkdir -p "$DOWNLOAD_DIR"

# Use the direct link to the ISO
WINDOWS11_URL="https://archive.org/download/Win11EnterpriseG24H2English/Windows_11_24H2_Enterprise_G.iso"

# Extract the ISO file name
ISO_NAME=$(basename "$WINDOWS11_URL")

echo "Downloading Windows 11 ISO to $DOWNLOAD_DIR/$ISO_NAME..."

# Download the ISO file, ignoring SSL certificate errors
wget --no-check-certificate -q --show-progress -O "$DOWNLOAD_DIR/$ISO_NAME" "$WINDOWS11_URL"

if [ $? -eq 0 ]; then
  echo "Download complete! The ISO is saved at $DOWNLOAD_DIR/$ISO_NAME."
else
  echo "Failed to download the ISO. Please check your connection or the URL."
fi
