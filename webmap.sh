#/bin/bash

sudo apt -y install curl gnupg2 apt-transport-https software-properties-common ca-certificates 
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
echo "deb [arch=amd64] https://download.docker.com/linux/debian buster stable" | sudo tee  /etc/apt/sources.list.d/docker.list
sudo apt update
#
sudo apt install docker-ce docker-ce-cli containerd.io -y
cd /opt/
git clone https://github.com/SabyasachiRana/WebMap.git
cd WebMap/
#
docker exec -ti webmap /root/token
mkdir -p /tmp/webmap
#
docker run -d --name webmap -h webmap -p 8000:8000 -v /tmp/webmap:/opt/xml reborntc/webmap
docker exec -ti webmap /root/token

