#/bin/bash
# Start WebMap
sudo docker rm webmap
sudo docker pull reborntc/webmap
#
sudo mkdir -p /tmp/webmap
sudo docker run -d \
         --name webmap \
         -h webmap \
         -p 8000:8000 \
         -v /tmp/webmap:/opt/xml \
         reborntc/webmap
#
sudo docker exec -ti webmap /root/token
