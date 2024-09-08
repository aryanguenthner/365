# Microsoft Edge Kali Linux Installer

# 2024-09-04

cd /opt

curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/

sudo apt-get update && sudo apt-get install -y microsoft-edge-stable

#sudo rm /etc/apt/sources.list.d/microsoft-edge-dev.list

# Edge Uninstall sudo apt-get remove microsoft-edge-* -y

exit
