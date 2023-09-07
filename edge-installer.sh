# Microsoft Edge Kali Linux Installer

# 2023-09-05

cd /opt

curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/

sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge-dev.list'


sudo apt-get update && sudo apt-get install -y microsoft-edge-stable

# Edge Uninstall sudo apt-get remove microsoft-edge-* -y

exit
