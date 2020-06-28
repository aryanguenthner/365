#/bin/bash
# Start WebMap
docker rm webmap
docker pull reborntc/webmap
#
mkdir -p /tmp/webmap
docker run -d \
         --name webmap \
         -h webmap \
         -p 8000:8000 \
         -v /tmp/webmap:/opt/xml \
         reborntc/webmap
#
docker exec -ti webmap /root/token
