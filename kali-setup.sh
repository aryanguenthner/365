#!/usr/bin/env bash

################################################
# Kali Linux Red Team Setup Automation Script
# Tested on Kali 2022.4
# Usage: cd /opt/
# sudo git clone https://github.com/aryanguenthner/365
# cd 365
# sudo chmod a+x *.sh *.py
# sudo ./kali-setup.sh | tee kali.log
# chmod -R 777 /home/kali/
# Last Updated 06/09/2023, minor evil updates
################################################

# Setting Variables
YELLOW=033m
BLUE=034m
KALI=`hostname -I`
SUBNET=`ip r | awk 'NR==2' | awk '{print $1}'`

# Todays Date 
echo -e "\e[034mToday is\e[0m"
date '+%Y-%m-%d %r' | tee kali-setup-date.txt
echo

# Networking, Modified for IPv4
echo -e "\e[033mNetwork Information\e[0m"
echo
echo -e "\e[033mPublic IP\e[0m"
curl -s https://ipapi.co/timezone
echo
curl -s ifconfig.me
echo
echo
# Internal IP Address
echo -e "\e[033mKali IP\e[0m"
echo $KALI | awk '{print $1}'
echo

# Subnet
echo -e "\e[033mCurrent Subnet\e[0m"
echo $SUBNET
echo
sleep 2

# Keep Nmap scans Organized
mkdir -p /home/kali/Desktop/testing/nmapscans/
chmod -R 777 /home/kali/
echo

# Kali Updates
echo "It's a good idea to update and upgrade Kali first before running kali-setup.sh"
echo
echo "Be Patient, Installing Kali Dependencies"

# Kali installs
apt update && apt -y upgrade && apt -y full-upgrade
echo
sudo apt-get install hcxdumptool hcxtools assetfinder colorized-logs xfce4-weather-plugin npm ncat shotwell obfs4proxy gconf-service gconf2-common libc++1 libgconf-2-4 sendmail libgl1-mesa-glx libegl1-mesa libxcb-xtest0 ibus feroxbuster virtualenv mailutils mpack ndiff docker docker.io docker-compose containerd python3-dev pip python3-pip python3-bottle python3-cryptography python3-dbus python3-future python3-matplotlib python3-mysqldb python3-openssl python3-pil python3-psycopg2 python3-pymongo python3-sqlalchemy python3-tinydb python3-py2neo at bloodhound ipcalc nload crackmapexec hostapd dnsmasq gedit cupp nautilus dsniff build-essential cifs-utils cmake curl ffmpeg gimp git graphviz imagemagick libapache2-mod-php php-xml libmbim-utils nfs-common openssl tesseract-ocr vlc wkhtmltopdf xsltproc xutils-dev driftnet websploit apt-transport-https openresolv screenfetch baobab speedtest-cli libffi-dev libssl-dev libxml2-dev libxslt1-dev zlib1g-dev awscli sublist3r w3m jq hplip printer-driver-hpcups cups system-config-printer gobuster tcpxtract libreoffice -y
echo

# Just Go for the win
wget https://go.dev/dl/go1.20.5.linux-amd64.tar.gz
tar -xvf https://go.dev/dl/go1.20.5.linux-amd64.tar.gz
sudo mv go /usr/local

# Get Pippy wit it
python3 -m pip install --upgrade pip
pip3 install --upgrade setuptools
echo
echo "Installing psycopg"
pip3 install psycopg
echo

'''https://www.kali.org/docs/virtualization/install-virtualbox-host/#setup
https://wiki.debian.org/VirtualBox#Debian_10_.22Buster.22_and_Debian_11_.22Bullseye.22
https://www.kali.org/docs/virtualization/install-virtualbox-host/
https://wiki.debian.org/VirtualBox
'''
echo "Are you installing a Kali Virtual Machine? "
sudo dmidecode -t system | tee /home/kali/Desktop/kali-system-info.log
VM="$(grep 'Product Name: Virtual Machine\|Product Name: VMware Virtual Platform' kali-system-info.log)"
VM1="Product Name: Virtual Machine"
VM2="Product Name: VMware Virtual Platform"

if [ $VM "Product Name: Virtual Machine" -o $VM "Product Name: VMware Virtual Platform" ]
then

    echo "Virtualization Detected - Skipping"

else

    echo "Bare Metal installling Vbox"

# Add gpg keys
sudo curl -fsSL https://www.virtualbox.org/download/oracle_vbox_2016.asc|sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/oracle_vbox_2016.gpg
sudo curl -fsSL https://www.virtualbox.org/download/oracle_vbox.asc|sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/oracle_vbox.gpg

# Add Repo
sudo echo "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian stretch contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list

# Update
sudo apt update

# Install dkms
sudo apt install -y dkms

# Install
sudo apt -y install linux-headers-`uname -r` build-essential virtualbox virtualbox-ext-pack virtualbox-guest-utils
echo

# VirtualBox Hack for USB Devices
sudo usermod -a -G vboxusers $USER
echo

fi
echo

# Customize Kali
echo 'hostname -I' >> /root/.zshrc
echo 'export HISTCONTROL="ignoredups:$PATH"' >> /root/.zshrc
echo 'export GOROOT="/usr/local/go"' >> /root/.zshrc
echo 'export GOPATH="$HOME/go"' >> /root/.zshrc
echo 'export PATH="$GOPATH/bin:$GOROOT/bin:$PATH"' >> /root/.zshrc
echo 'export PATH="PATH=$PATH:$GOROOT/bin/:$GOPATH/bin"' >> /root/.zshrc
echo 'export PATH="$PATH:$(go env GOPATH)/bin"' >> /root/.zshrc
echo 'export PATH="/root/go:$PATH"' >> /root/.zshrc
echo 'export PATH="/usr/local/go/bin:$PATH"' >> /root/.zshrc
echo 'export PATH="/root/work:$PATH"' >> /root/.zshrc
echo 'export PATH="/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/games:/usr/games:$PATH"' >> /root/.zshrc
echo 'export PATH="/usr/bin:/usr/bin:=/usr/lib/jvm/java-11-openjdk-amd64/:/snap/bin/:$PATH"' >> /root/.zshrc 
echo 'export PATH="/usr/sbin:/usr/bin:=/usr/lib/jvm/java-11-openjdk-amd64/:/snap/bin/:$PATH"' >> /root/.zshrc
echo 'export PATH="/usr/lib/jvm/java-11-openjdk-amd64/:$PATH"' >> /root/.zshrc
echo 'export PATH="/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/games:/usr/games:$PATH"' >> /root/.zshrc
echo 'export PATH="/usr/local/bin:$PATH"' >> /root/.zshrc
echo

# TODO
# https://github.com/balena-io/etcher
'''echo "Downloading Etcher USB Media Creator"
curl -1sLf \
   'https://dl.cloudsmith.io/public/balena/etcher/setup.deb.sh' \
   | sudo -E bash

echo

sudo apt-get update
echo "Etcher USB-"
mkdir -p /opt/balena-etcher-electron/chrome-sandbox
sudo apt-get install balena-etcher-electron -y
echo
'''


# TODO: Check this out
# text in your terminal > ansi2html -a > report.html
# ssmtp <--works good, just doesnt play with sendmail.
# did not install > openjdk-13-jdk libc++1-13 libc++abi1-13 libindicator3-7 libunwind-13 python3.8-venv libappindicator3-1 

echo

# TODO: Slack Setup on Kali needs some love
# curl https://packagecloud.io/install/repositories/slacktechnologies/slack/script.deb.sh . 
# chmod +x script.deb.sh
# os=debian dist=stretch ./script.deb.sh

# Nmap bootstrap file checker, creates beautiful nmap reports
NB=nmap-bootstrap.xsl
if [ -f $NB ]
then

    echo "Found nmap-bootstrap.xsl"

else

    echo -e "\e[034mDownloading Missing $BOOTSTRAP File\e[0m"
wget --no-check-certificate -O /home/kali/Desktop/testing/nmapscans/nmap-bootstrap.xsl https://raw.githubusercontent.com/aryanguenthner/nmap-bootstrap-xsl/stable/nmap-bootstrap.xsl > /dev/null

fi
echo

# Did you say Cloudflare Tunnel?
# qterminal -e python3 -m http.server 4567
# qterminal -e cloudflared tunnel -url localhost:4567


dpkg -i /opt/365/cloudflared-linux-amd64.deb

# Project Discovery Nuclei
cd /opt
go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
echo

# Project Discovery httpx
cd /opt
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
echo

# Install Katana - Web Crawler
cd /opt
go install -v github.com/projectdiscovery/katana/cmd/katana@latest
echo

# Install Project Discovery - Uncover
cd /opt
go install -v github.com/projectdiscovery/uncover/cmd/uncover@latest
echo

# Install Project Discovery - Uncover
cd /opt
go install -v github.com/projectdiscovery/subfinder/cmd/subfinder@latest
echo

# Install gospider - Web Crawler
# https://github.com/jaeles-project/gospider
go install github.com/jaeles-project/gospider@latest

# Install gobuster - Directory Buster
go install github.com/OJ/gobuster/v3@latest

# How to Update Python Alternatives
''' # kali python Config
ls -l /usr/bin/python*
sudo update-alternatives --list python
sudo update-alternatives --config python
sudo update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.9 3
sudo update-alternatives --set python /usr/bin/python3.9
# update-alternatives --remove-all python

#kali python3 Config
ls -l /usr/bin/python*
sudo update-alternatives --list python3
sudo update-alternatives --config python3
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 2
sudo update-alternatives --set python3 /usr/bin/python3.9
# update-alternatives --remove-all python
'''
echo

# Signal
# NOTE: These instructions only work for 64 bit Debian-based Kali Linux
# Linux distributions such as Ubuntu, Mint etc.
# 1. Install our official public software signing key
wget --no-check-certificate -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg
cat signal-desktop-keyring.gpg | sudo tee -a /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null

# 2. Add our repository to your list of repositories
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |\
sudo tee -a /etc/apt/sources.list.d/signal-xenial.list

# 3. Update your package database and install signal
sudo apt update && sudo apt install -y signal-desktop
echo

# Hackers like SSH
echo "Enabling SSH"
sed -i '40s/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
sudo systemctl enable ssh
sudo service ssh restart
echo

# TODO
# Replace Nmap User agent
# "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko)"
# Line 159 /usr/share/nmap/nselib/http.lua

# TODO: Yeet
#echo "Kingfisher"
#echo
#cd /opt
# git clone https://github.com/onevcat/Kingfisher.git
echo

echo "PWN AD"
cd /opt
git clone https://github.com/Wh04m1001/DFSCoerce
echo
echo "Malicious Macro Builder"
cd /opt
git clone https://github.com/infosecn1nja/MaliciousMacroMSBuild.git
echo
echo "metagoofil"
sudo apt -y install metagoofil
echo
echo "Setting up Knock - Subdomain Finder"
cd /opt
git clone https://github.com/guelfoweb/knock.git
cd knock
#nano knockpy/config.json <- set your virustotal API_KEY
pip install -e .
echo
echo "Subbrute"
echo
cd /opt
git clone https://github.com/TheRook/subbrute.git
echo
echo "dnstwister"
echo
cd /opt
git clone https://github.com/elceef/dnstwist.git
sudo apt-get -y install python3-dnspython python3-geoip python3-whois python3-requests python3-ssdeep python3-dns

echo
echo
echo "Cewl Password Lists"
cd /opt
git clone https://github.com/digininja/CeWL.git
gem install mime-types
gem install mini_exiftool
gem install rubyzip
gem install spider
echo
echo "This is going to take a minute hold my root-beer"
echo

echo "AD Recon - My Fav"
cd /opt
git clone https://github.com/sense-of-security/ADRecon.git
echo

echo "enum4linux-ng"
cd /opt
git clone https://github.com/cddmp/enum4linux-ng.git
echo

echo "BloodHound"
cd /opt
git clone https://github.com/BloodHoundAD/Bloodhound.git
echo

echo "Daniel Miessler Security List Collection"
cd /opt
git clone https://github.com/danielmiessler/SecLists.git
echo

echo "Awesome Incident Response"
cd /opt
git clone https://github.com/meirwah/awesome-incident-response.git
echo

echo "Fuzzdb"
cd /opt
git clone https://github.com/fuzzdb-project/fuzzdb.git
echo

echo "Payloads All The Things"
cd /opt
git clone https://github.com/swisskyrepo/PayloadsAllTheThings.git
echo

# TODO: echo "OneListForAll"
# cd /opt
# git clone https://github.com/six2dez/OneListForAll.git
# cd OneListForAll
# 7z x onelistforall.7z.001
# wget https://raw.githubusercontent.com/NotSoSecure/password_cracking_rules/master/OneRuleToRuleThemAll.rule
# wget https://github.com/NotSoSecure/password_cracking_rules/blob/master/OneRuleToRuleThemAll.rule
# wget -O rules.txt https://contest-2010.korelogic.com/rules.txt
# cat rules.txt >> /etc/john/john.conf
# echo

echo "SprayingToolKit"
cd /opt
git clone https://github.com/byt3bl33d3r/SprayingToolkit.git
: ' Nmap works dont forget --> nmap -Pn -p 445 -script smb-brute --script-args='smbpassword=Summer2019,smbusername=Administrator' 192.168.1.23 '
echo
: ' Hydra works dont forget --> hydra -p Summer2019 -l Administrator smb://192.168.1.23 '
: ' Metasploit works dont forget --> 
set smbpass Summer2019
set smbuser Administrator
set rhosts 192.168.1.251
run '

echo "Awesome XSS"
cd /opt
git clone https://github.com/s0md3v/AwesomeXSS.git
echo

echo "XSS Payloads"
cd /opt
git clone https://github.com/payloadbox/xss-payload-list.git
echo

echo "Foospidy Payloads"
cd /opt
git clone https://github.com/foospidy/payloads.git
echo

echo "Java Deserialization Exploitation (jexboss)"
cd /opt
git clone https://github.com/joaomatosf/jexboss.git
echo

echo "theHarvester"
cd /opt
git clone https://github.com/laramies/theHarvester.git
echo

echo "OWASP Cheat Sheet"
cd /opt
git clone https://github.com/OWASP/CheatSheetSeries.git
echo

echo "Pulse VPN Exploit"
cd /opt
git clone https://github.com/projectzeroindia/CVE-2019-11510.git
echo

echo "hruffleHog - Git Enumeration"
cd /opt
git clone https://github.com/dxa4481/truffleHog.git
echo

echo "Git Secrets"
cd /opt
git clone https://github.com/awslabs/git-secrets.git
echo

echo "Git Leaks"
cd /opt
git clone https://github.com/zricethezav/gitleaks.git

echo "Discover Admin Loging Pages - Breacher"
cd /opt
git clone https://github.com/s0md3v/Breacher.git
echo

echo "Installing Impacket"
cd /opt
sudo pip3 install jinja2==2.10.1
git clone https://github.com/SecureAuthCorp/impacket.git
cd /opt
cd impacket
pip3 install -e .
echo

echo "GitRob"
cd /tmp
sudo wget --no-check-certificate https://github.com/michenriksen/gitrob/releases/download/v2.0.0-beta/gitrob_linux_amd64_2.0.0-beta.zip
unzip gitrob_linux_amd64_2.0.0-beta.zip
mkdir -p /opt/gitrob
mv gitrob /opt/gitrob/
echo

echo "OSINT Phone Number Info Gathering Tool"
cd /opt
sudo git clone https://github.com/sundowndev/PhoneInfoga.git
cd PhoneInfoga
sudo curl -sSL https://raw.githubusercontent.com/sundowndev/PhoneInfoga/master/support/scripts/install | bash\n
sudo ./phoneinfoga version
echo

# Windows Exploit Suggester Next Gen
echo
cd /opt
sudo git clone https://github.com/bitsadmin/wesng.git
echo

echo "Hacker Hacker"
cd /opt
git clone https://github.com/aryanguenthner/365.git
cd 365
sudo dos2unix *.sh *.py && chmod a+x *.sh *.py
chmod -R 777 /opt/365
echo

# MongoDB Install
echo "Installing MongoDB 4.2 from Ubuntu Repo, Because It Works"
echo
cd /tmp
wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | apt-key add -
echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.2.list
apt update
sudo apt -y install mongodb-org
service mongod start
systemctl enable mongod.service
echo "Hopefully MongoDB Installed"
echo

# Fix annoying apt-key
sudo apt-key export 058F8B6B | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/mongo.gpg

# Ivre Dependencies
sudo pip install tinydb
sudo pip install py2neo
echo

# Install Ivre.Rocks
echo
sudo apt -y install ivre
echo

# Ivre Database init, data download & importation
echo
echo -e '\r'
yes | ivre ipinfo --init
yes | ivre scancli --init
yes | ivre view --init
yes | ivre flowcli --init
yes | sudo ivre runscansagentdb --init
# 40 Min download --> sudo ivre ipdata --download
echo -e '\r'
echo

# Ivre Nmap Magic
echo
echo "Copying IVRE Nmap Scripts to Nmap"
echo
cp /usr/share/ivre/patches/nmap/scripts/*.nse /usr/share/nmap/scripts/
yes | patch /usr/share/nmap/scripts/rtsp-url-brute.nse \
/usr/share/ivre/patches/rtsp-url-brute.patch
nmap --script-updatedb > /dev/null
echo

# Get nmap scripts
cd /usr/share/nmap/scripts
wget --no-check-certificate https://raw.githubusercontent.com/aryanguenthner/nmap-nse-vulnerability-scripts/master/smtp-vuln-cve2020-28017-through-28026-21nails.nse
nmap --script-updatedb
echo

# http-screenshot Checker
N=/usr/share/nmap/scripts/http-screenshot.nse
if [ -f "$N" ]
then

    echo "Found http-screenshot.nse"

else

    echo "Downloading missing file http-screenshot.nse"
cd /usr/share/nmap/scripts
wget https://raw.githubusercontent.com/ivre/ivre/master/patches/nmap/scripts/http-screenshot.nse > /dev/null
nmap --script-updatedb > /dev/null

fi

# PhantomJS Checker
P=/usr/local/bin/phantomjs
if [ -f $P ]
then

    echo "Found PhantomJS 1.9.8"

else

    echo -e "\e[034mDownloading Missing PhantomJS\e[0m"

wget --no-check-certificate -O /opt/phantomjs-1.9.8-linux-x86_64.tar.bz2 https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.8-linux-x86_64.tar.bz2
tar xvjf phantomjs-1.9.8-linux-x86_64.tar.bz2
rm phantomjs-1.9.8-linux-x86_64.tar.bz2

echo "Extracting and Installing PhantomJS 1.9.8"
cd /opt
tar xvf phantomjs-1.9.8-linux-x86_64.tar.bz2
mv phantomjs-1.9.8-linux-x86_64 phantomjs
mv phantomjs /opt
ln -s /opt/phantomjs/bin/phantomjs /usr/local/bin/phantomjs

    echo "Phantomjs Version"
phantomjs -v

fi
echo

# Can I get a Witness?
# Get Screenshots
# ./gowitness file -f url-results.txt
# "View Report http://localhost:7171"
# ./gowitness server report
# Can I get a gowitness?
GWIT=/home/kali/Desktop/testing/urlwitness/gowitness
if [ -f "$GWIT" ]
then
    echo "Found gowitness"

else
    echo -e "\e[034mDownloading Missing $GWIT\e[0m"
wget --no-check-certificate 'https://drive.google.com/uc?export=download&id=1hXJAEQAFqFu5A4uR14dUWWdwWceLHz6D' -O /home/kali/Desktop/testing/urlwitness/gowitness
chmod -R 777 /home/kali

fi
echo

echo "The devils eye"
pip install thedevilseye==2022.1.4.0
# eye -q "hacker tools" | grep .onion > hackertoolse+onions.txt
echo

# Tor Web Browser Stuff
# sudo gpg --keyserver pool.sks-keyservers.net --recv-keys EB774491D9FF06E2 && 
sudo apt -y install torbrowser-launcher
cd /opt
sudo git clone https://github.com/aryanguenthner/TorGhost.git
cd TorGhost
sudo apt -y install python3-pyinstaller python3-notify2
sudo pip3 install . --ignore-installed stem
sudo ./build.sh
echo

# Remove Docker Interface until you need it
ip link delete docker0

echo "Hack The Planet"
echo

# Insurance
sudo apt-get --reinstall install python3-debian -y
sudo apt --fix-broken install
sudo apt autoremove -y
systemctl restart ntp
source ~/.zshrc
echo

# Install Finish Time
date | tee kali-setup-finish-date.txt

# Stop Docker
systemctl stop docker
systemctl disable docker
#
updatedb
# TODO: Add this to VLC https://broadcastify.cdnstream1.com/24051
reboot
# Just in case DNS issues: nano -c /etc/resolvconf/resolv.conf.d/head
# Gucci
