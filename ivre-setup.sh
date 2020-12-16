################################################
# IVRE Post Kali Install Tested on Kali 2020.4
# First Make This File Executable chmod +x *.sh
# Usage: ./ivre-setup.sh 
# Learn more at https://github.com/aryanguenthner
# Last Updated 11/23/2020
: 'EXAMPLE: nmap somesite.com/22 -g 53 --mtu 24 -T4 -A -PS -PE -p- -vv -r --open --max-retries 0 --max-parallelism 200 -sC --host-timeout 15m --script-timeout 2m --script=ssl-cert,ssl-enum-ciphers,ssl-heartbleed,sip-enum-users,sip-brute,sip-methods,rtsp-screenshot,rtsp-url-brute,rpcinfo,vnc-screenshot,x11-access,x11-screenshot,nfs-showmount,nfs-ls,smb-ls,smb-enum-shares,http-robots.txt.nse,http-webdav-scan,http-screenshot,http-auth,http-sql-injection,http-ntlm-info,http-git,http-open-redirect,http-open-proxy,socks-open-proxy,smtp-open-relay,ftp-anon,ftp-bounce,ms-sql-config,ms-sql-info,ms-sql-empty-password,mysql-info,mysql-empty-password,vnc-brute,vnc-screenshot,vmware-version,http-shellshock,http-default-accounts -oA nmapivre && ivre scan2db *.xml && ivre db2view nmap'
echo
date | tee ivre-startdate.txt
echo "Installing MongoDB 4.2 from Ubuntu Repo, Because It Works"


# MongoDB Install

cd /tmp
wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | apt-key add -
echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.2.list
apt update
apt -y install mongodb-org
service mongod start
systemctl enable mongod.service
echo "Hopefully MongoDB Installed without any issues"
echo

# Install Ivre

apt -y install

# Dependencies
# TODO: Determine if we are using APT or PIP
sudo apt -y install python3-pip python3-bottle python3-cryptography python3-dbus python3-future python3-matplotlib python3-mysqldb python3-openssl python3-pil python3-psycopg2 python3-pymongo python3-sqlalchemy python3-tinydb python3-py2neo

pip install --upgrade pip

: 'echo "Attepting To Installing Some IVRE Dependencies"
echo
pip install future
pip install matplotlib
pip install tinydb
pip install Crypto
pip install pymongo
pip install py2neo
pip install sqlalchemy
pip install bottle
pip install psycopg2
echo
'
# Nmap Magic

echo "Copying IVRE Nmap Scripts to Nmap"
sudo apt -y install nmap
echo
cp /usr/local/share/ivre/nmap_scripts/*.nse /usr/share/nmap/scripts/
patch /usr/share/nmap/scripts/rtsp-url-brute.nse \
/usr/local/share/ivre/nmap_scripts/patches/rtsp-url-brute.patch
nmap --script-updatedb

# Enable Ivre Nmap Screenshots

cd /opt
wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.8-linux-x86_64.tar.bz2
tar xvf phantomjs-1.9.8-linux-x86_64.tar.bz2
mv phantomjs-1.9.8-linux-x86_64 phantomjs
mv phantomjs /opt
ln -s /opt/phantomjs/bin/phantomjs /usr/local/bin/phantomjs
phantomjs -v
echo

# Database init, data download & importation

echo -e '\r'
yes | ivre ipinfo --init # Run to Clear Dashboard
yes | ivre scancli --init #Run to Clear Dashboard
yes | ivre view --init #Run to Clear Dashboard
yes | ivre flowcli --init
yes | sudo ivre runscansagentdb --init
sudo ivre ipdata --download
echo -e '\r'

# Start IVRE Dashboard

service apache2 start  ## reload or start
echo
IP=`hostname -I`
PORT=8888
echo
echo "IVRE IP Address" $IP
echo
echo "Step 1) ivre scan2db *.xml"
echo
echo -e '\r'
echo "Step 2) ivre db2view nmap"
echo
echo -e '\r'
echo "Step 3) Open IVRE Dashbaord"
#TODO escape ":" so there isn't a break in the dashboard url
echo "http://$IP:$PORT"
echo
ivre httpd --bind-address 0.0.0.0 --port $PORT
echo -e '\r'

