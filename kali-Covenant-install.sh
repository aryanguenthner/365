#!/bin/bash
# 03/17/2021 - C2 Server  Covenant - Kali - 2021.1
#
# https://github.com/cobbr/Covenant/wiki/Installation-And-Startup
# https://docs.microsoft.com/en-gb/dotnet/core/install/linux-debian

# Update Kali
sudo apt update && apt -y upgrade

cd /tmp

# Install the SDK
wget https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb

# Install the runtime
sudo apt-get update; \
sudo apt-get install -y apt-transport-https && \
sudo apt-get update && \
sudo apt-get install -y dotnet-sdk-3.1
sudo apt-get install -y dotnet-runtime-3.1

# Once you have installed dotnet core, we can build and run Covenant using the dotnet CLI:

cd /opt
git clone --recurse-submodules https://github.com/cobbr/Covenant
cd /opt/Covenant/Covenant
dotnet run
