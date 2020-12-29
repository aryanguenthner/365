################################################
# IVRE Post Kali Install Tested on Kali 2020.4
# First Make This File Executable chmod +x *.sh
# Usage: ./ivre-setup.sh 
# Learn more at https://github.com/aryanguenthner
# Last Updated 12/28/2020

echo
echo
: 'EXAMPLE: nmap somesite.com/22 -g 53 --mtu 24 -T4 -A -PS -PE -p- -vv -r --open --max-retries 0 --max-parallelism 100 -sC --host-timeout 15m --script-timeout 2m --script=ssl-cert,ssl-enum-ciphers,ssl-heartbleed,sip-enum-users,sip-brute,sip-methods,rtsp-screenshot,rtsp-url-brute,rpcinfo,vnc-screenshot,x11-access,x11-screenshot,nfs-showmount,nfs-ls,smb-ls,smb-enum-shares,http-robots.txt.nse,http-webdav-scan,http-screenshot,http-auth,http-sql-injection,http-ntlm-info,http-git,http-open-redirect,http-open-proxy,socks-open-proxy,smtp-open-relay,ftp-anon,ftp-bounce,ms-sql-config,ms-sql-info,ms-sql-empty-password,mysql-info,mysql-empty-password,vnc-brute,vnc-screenshot,vmware-version,http-shellshock,http-default-accounts,vuln -oA nmapivre && ivre scan2db *.xml && ivre db2view nmap'
echo "# Usage: ./ivre-setup.sh | tee ivre.log"
echo "Installing MongoDB 4.2 from Ubuntu Repo, Because It Works"
echo
# MongoDB Install
echo
cd /tmp
wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | apt-key add -
echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.2.list
apt update
apt -y install mongodb-org
service mongod start
systemctl enable mongod.service
echo "Hopefully MongoDB Installed without any issues"
echo
apt -y install python3-pip
echo
# Install Ivre
echo
pip install ivre
echo
# Dependencies
pip install tinydb
pip install py2neo
echo
# Nmap Magic
echo
echo "Copying IVRE Nmap Scripts to Nmap"
sudo apt -y install nmap
echo
cp /usr/local/share/ivre/nmap_scripts/*.nse /usr/share/nmap/scripts/
yes | patch /usr/share/nmap/scripts/rtsp-url-brute.nse \
/usr/local/share/ivre/nmap_scripts/patches/rtsp-url-brute.patch
nmap --script-updatedb
echo
# Enable Ivre Nmap Screenshots
echo
cd /opt
wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.8-linux-x86_64.tar.bz2
tar xvf phantomjs-1.9.8-linux-x86_64.tar.bz2
mv phantomjs-1.9.8-linux-x86_64 phantomjs
mv phantomjs /opt
ln -s /opt/phantomjs/bin/phantomjs /usr/local/bin/phantomjs
phantomjs -v
echo
echo
# Database init, data download & importation
echo
yes | ivre ipinfo --init # Run to Clear Dashboard
yes | ivre scancli --init #Run to Clear Dashboard
yes | ivre view --init #Run to Clear Dashboard
yes | ivre flowcli --init
yes | sudo ivre runscansagentdb --init
sudo ivre ipdata --download
echo
# Start IVRE Dashboard
echo
service apache2 start  ## reload or start
echo
echo
echo "IVRE IP Address" $IP
echo
echo "Step 1) ivre scan2db *.xml"
echo
echo "Step 2) ivre db2view nmap"
echo
echo "Step 3) Open IVRE Dashbaord"
echo
ivre httpd --bind-address 0.0.0.0 --port 9999
echo
# hacker hacker
