#!/bin/bash
################################################
# IVRE Install Script
# Tested on Kali 2020.1 x64
# If you're reading this pat yourself on the back
# Then do this dos2unix ivre-setup.sh
# Then do this chmod +x ivre-setup.sh 
# Usage: ./ivre-setup.sh | tee ivrelog.txt
# Learn more at https://github.com/aryanguenthner/
# Last Updated 04/08/2020
################################################
: ' 2020-04-08
TARGETS=192.168.1.0/24
KALI=`hostname -I`
nmap -iL $TARGETS --exclude=$KALI -Pn -T4 -A -sC -p- -vvvv -r --open --max-retries 0 --max-parallelism 100 --script=mainframe-banner,mainframe-screenshot,rtsp-screenshot,rpcinfo,vnc-screenshot,x11-access,x11-screenshot,nfs-showmount,nfs-ls,smb-enum-shares,http-robots.txt.nse,http-screenshot,http-auth,http-sql-injection,http-git,http-open-proxy,socks-open-proxy,smtp-open-relay,ftp-anon,ftp-bounce,ms-sql-empty-password,mysql-empty-password,vnc-brute,http-shellshock,http-default-accounts -oA nmapivre && ivre scan2db nmapivre.xml && ivre db2view nmap'
echo
date | tee ivre-startdate.txt
echo "Installing MongoDB 4.2 from Ubuntu Repo, Because It Works"
echo
cd /tmp
wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | apt-key add -
echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.2.list
apt-get -y update
apt-get -y install mongodb-org
service mongod start
systemctl enable mongod.service
echo "Hopefully MongoDB Installed without any issues"
echo
echo "Installing IVRE"
echo
echo "Be Patient, Not a lot of output on this portion of the install"
echo
date
echo
apt-get -y install python-pymongo python-crypto \
> python-future apache2 libapache2-mod-wsgi libkrb5-dev dokuwiki
# Installing the Latest version of IVRE from Github
echo
echo "Attepting To Installing Some IVRE Dependencies"
cd /tmp
apt-get install python-pip && pip install -U pip
wget https://bootstrap.pypa.io/get-pip.py
python get-pip.py
echo
pip install python-krbv
pip install matplotlib
pip install tinydb
pip install Crypto
pip install pymongo
pip install py2neo
pip install sqlalchemy
pip install bottle
pip install psycopg2
echo
echo "Git Clone IVRE to /opt"
echo
cd /opt
git clone https://github.com/cea-sec/ivre.git
cd ivre
python setup.py build
python setup.py install
echo
echo "IVRE Setup In Progress"
echo
cd /var/www/html ## or depending on your version /var/www
rm index.html
sed -i -e 's/html/dokuwiki/g' /etc/apache2/sites-enabled/000-default.conf
sed -i -e '172s/None/All/g' /etc/apache2/apache2.conf
ln -s /usr/local/share/ivre/web/static/* .
cd /var/lib/dokuwiki/data/pages
ln -s /usr/local/share/ivre/dokuwiki/doc
cd /var/lib/dokuwiki/data/media
ln -s /usr/local/share/ivre/dokuwiki/media/logo.png
ln -s /usr/local/share/ivre/dokuwiki/media/doc
cd /usr/share/dokuwiki
echo
echo "Patching Dokuwiki"
echo
patch -p0 < /usr/local/share/ivre/dokuwiki/backlinks.patch
cd /etc/apache2/mods-enabled
for m in rewrite.load wsgi.conf wsgi.load; do
> '[ -L $m ]' || ln -s ../mods-available/$m; done
cd ../
echo 'Alias /cgi "/usr/local/share/ivre/web/wsgi/app.wsgi"' > conf-enabled/ivre.conf
echo '<Location /cgi>' >> conf-enabled/ivre.conf
echo 'SetHandler wsgi-script' >> conf-enabled/ivre.conf
echo 'Options +ExecCGI' >> conf-enabled/ivre.conf
echo 'Require all granted' >> conf-enabled/ivre.conf
echo '</Location>' >> conf-enabled/ivre.conf
rm /etc/dokuwiki/apache.conf
cp /etc/apache2/apache2.conf /etc/dokuwiki/
sed -i 's/^\(\s*\)#Rewrite/\1Rewrite/' /etc/dokuwiki/apache2.conf
echo 'WEB_GET_NOTEPAD_PAGES = "localdokuwiki"' >> /etc/ivre.conf
service apache2 start
echo
echo "Copying IVRE Nmap Scripts to Nmap"
echo
cp /usr/local/share/ivre/nmap_scripts/*.nse /usr/share/nmap/scripts/
# TODO: Get confirmation this rtsp script is working or not
#patch /usr/share/nmap/scripts/rtsp-url-brute.nse \
#> /usr/local/share/ivre/nmap_scripts/patches/rtsp-url-brute.patch
nmap --script-updatedb
echo "Downloading Neo4j to tmp"
cd /tmp
echo "Installing Neo4j"
wget -O - https://debian.neo4j.org/neotechnology.gpg.key | apt-key add -
echo 'deb https://debian.neo4j.org/repo stable/' | tee -a /etc/apt/sources.list.d/neo4j.list
apt-get -y update
apt-get install -y neo4j
systemctl enable neo4j
echo
echo "Now Starting The Database init, data download & importation"
date
echo "These last steps may take a long time to run (40 minutes on a decent server), nothing to worry about."
echo -e "\r\n\r\n"
yes | ivre ipinfo --init
yes | ivre scancli --init
yes | ivre view --init
yes | ivre flowcli --init
ivre ipdata --download --import-all
updatedb
echo "Just About There"
echo
echo "You Will Need To Import Nmap Files To Get Started"
echo
echo "Import nmapscanfile.xml files like this: ivre scan2db nmapscan.xml"
echo
date | tee ivre-setup-finishdate.txt
echo "After Importing do this: ivre db2view nmap"
#Open a web browser and visit http://localhost:8888/
#IVRE Web UI should show up, with no result of course
#Click the HELP button to check if everything works
#Database init, data download & importation
# Time to start using IVRE: Bind localhost to -p8888
# When the Web Interface for IVRE Opens you're ready!
echo
echo "Step 1) ivre scan2db somenmapfile.xml"
echo
echo "Step 2) ivre db2view nmap"
echo
echo "Step 3) Access the IVRE Dashboard"
updatedb
echo "Your IP Address"
hostname -I
ivre httpd --bind-address 0.0.0.0 --port 8888


