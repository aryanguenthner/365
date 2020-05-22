#!/bin/bash
# Usage:
# root@ubuntu:/opt/rawr# ./rawr.py 192.168.1.35 -p all --dns -a -v -o -z -r --rd -S5 --spider --downgrade --sslv -d /home/secops/Desktop/
echo
apt-get upadte && apt-get upgrade -y
echo
echo
cd /tmp
wget https://bootstrap.pypa.io/get-pip.py
python get-pip.py
echo
echo "Upgrading pip"
echo
python -m pip install --upgrade pip
echo
echo
apt -y install nmap git python python-xlsxwriter python-lxml \
>  python-qt4 python-pil python-pygraphviz python-pyside.qtwebkit
echo
echo "Instaling RAWR"
cd /opt
git clone https://bitbucket.org/al14s/rawr.git
cd rawr
yes | ./install.sh
yes | ./rawr -U