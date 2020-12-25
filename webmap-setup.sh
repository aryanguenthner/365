#/bin/bash
# WebMap Nmap Dashboard Pentest Collaboration
sudo apt update
sudo apt -y install curl gnupg2 apt-transport-https software-properties-common ca-certificates
sudo curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
echo "deb [arch=amd64] https://download.docker.com/linux/debian buster stable" | sudo tee  /etc/apt/sources.list.d/docker.list
sudo apt update
#
sudo apt -t install docker.io docker-ce docker-ce-cli containerd.io
cd /opt/
sudo git clone https://github.com/SabyasachiRana/WebMap.git
cd WebMap/
#
sudo docker exec -ti webmap /root/token
sudo mkdir -p /tmp/webmap
#
sudo docker run -d --name webmap -h webmap -p 8000:8000 -v /tmp/webmap:/opt/xml reborntc/webmap
sudo docker exec -ti webmap /root/token | tee webmap_token.txt
echo "Gucci"

