apt update
sudo apt -y install snapd 
sudo snap install core
sudo snap install snapd
sudo snap install snap-store
sudo snap install whatsdesk
sudo snap refresh core
systemctl start snapd.service
mkdir -p /run/user/0
#snap run whatsdesk
