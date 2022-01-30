# Stop Docker networking interface
# https://www.thegeekdiary.com/how-to-disable-docker-process-and-docker0-interface-on-centos-rhel/
service docker stop
systemctl stop docker
ip link delete docker0
systemctl disable docker
sudo systemctl disable docker --now
ip link set dev br-658bcad19dda down
