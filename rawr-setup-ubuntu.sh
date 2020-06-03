#!/bin/bash
# Usage:
# root@ubuntu:/opt/rawr# ./rawr.py ips.txt -p all --dns -a -v -o -z -r --rd -S5 --spider --downgrade --sslv -d /home/aryan/Desktop/rawr-data
echo
apt update && apt -y upgrade
echo
echo
apt -y install 
echo
apt -y install nmap git python python-xlsxwriter python-lxml python-qt4 python-pil python-pygraphviz python-pyside.qtwebkit python-pip screen
echo
echo "Instaling RAWR"
cd /opt
git clone https://github.com/aryanguenthner/rawr.git
cd rawr
yes | ./install.sh
yes | ./rawr -U