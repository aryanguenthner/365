#!/usr/bin/env bash

################################################
# Kali Linux Post Setup Automation Script VirtualBox
# Tested on Kali 2022.4.2
# If you're reading this pat yourself on the back
# sudo dos2unix *.sh && sudo chmod +x *.sh
# Usage: cd /opt/365
# chmod +x *.sh *.py && chmod -R 777 .
# sudo ./kali-setup.sh | tee kali.log
# Learn more at https://github.com/aryanguenthner/
# Last Updated 11/2/2022, Minor evil updates
################################################

# Setting Variables
YELLOW=033m
BLUE=034m
KALI=`hostname -I`
SUBNET=`ip r | awk 'NR==2' | awk '{print $1}'`
NMAP=`nmap -V | awk 'NR==1' | cut -d " " -f 1,2,3`
LS=`ls`

# Are you installling Kali in a virtual machine or bare metal?
dmidecode -t system
sleep 5
echo

# Todays Date 
echo -e "\e[034mToday is\e[0m"
date | tee kali-setup-date.txt
echo

# Files
echo -e "\e[034mFiles in your current directory ->$PWD\e[0m"
echo "$LS"
echo

# Networking
echo -e "\e[033mNetwork Information\e[0m"
echo
echo -e "\e[033mPublic IP\e[0m"
curl ifconfig.me
echo

# Internal IP Address
echo -e "\e[033mKali IP\e[0m"
echo $KALI | awk '{print $1}'
echo

# Subnet
echo -e "\e[033mCurrent Subnet\e[0m"
echo $SUBNET
echo

# Stay Organized
mkdir -p /home/kali/Desktop/testing/nmapscans/
chmod -R 777 /home/kali/
echo

# Kali Updates
echo "Good Idea to Update and Upgrade first before running kali-setup.sh"
echo
apt-get update && apt-get -y upgrade && apt-get -y full-upgrade && updatedb && apt-get -y autoclean
echo
echo "Be Patient, Installing Kali Dependencies"

# Kali installs
echo
sudo apt-get -y install shotwell obfs4proxy kbtin gconf-service gconf2-common libc++1 libc++1-13 libc++abi1-13 libgconf-2-4 libunwind-13 sendmail libgl1-mesa-glx libegl1-mesa libxcb-xtest0 ibus feroxbuster virtualenv mailutils mpack ndiff docker docker.io docker-compose containerd python3-dev pip python3-pip python3-bottle python3-cryptography python3-dbus python3-future python3-matplotlib python3-mysqldb python3-openssl python3-pil python3-psycopg2 python3-pymongo python3-sqlalchemy python3-tinydb python3-py2neo at bloodhound ipcalc nload crackmapexec hostapd dnsmasq gedit cupp nautilus dsniff build-essential cifs-utils cmake curl ffmpeg gimp git graphviz imagemagick libapache2-mod-php php-xml libmbim-utils nfs-common openssl tesseract-ocr vlc wkhtmltopdf xsltproc xutils-dev driftnet websploit apt-transport-https openresolv screenfetch baobab speedtest-cli libffi-dev libssl-dev libxml2-dev libxslt1-dev zlib1g-dev awscli sublist3r w3m jq hplip printer-driver-hpcups cups system-config-printer gobuster tcpxtract libreoffice
echo

# text in your terminal > ansi2html -a > report.html
# ssmtp <--works good, just doesnt play with sendmail.
#openjdk-13-jdk did not install
#libindicator3-7 did not install
#python3.8-venv did not install
#libappindicator3-1 did not install
echo

# Slack Setup on Kali needs some love
# curl https://packagecloud.io/install/repositories/slacktechnologies/slack/script.deb.sh . 
# chmod +x script.deb.sh
# os=debian dist=stretch ./script.deb.sh

# Nmap checker
NV=`nmap -V | awk 'NR==1' | cut -d " " -f 3`
if [ "$NV" = "7.93" ]
then
    echo "Found $NV"

else

    echo -e "\e[034mDownloading and installing Nmap 7.93\e[0m"

cd /tmp
wget https://nmap.org/dist/nmap-7.93.tar.bz2
bzip2 -cd nmap-7.93.tar.bz2 | tar xvf -
cd nmap-7.93
./configure
make
make install
echo $NMAP Installed
fi
echo

cd /usr/share/nmap/scripts
wget https://raw.githubusercontent.com/aryanguenthner/nmap-nse-vulnerability-scripts/master/smtp-vuln-cve2020-28017-through-28026-21nails.nse
nmap --script-updatedb
echo

cd /home/kali/
chmod -R 777 .

# Nmap Testing
mkdir -p /home/kali/Desktop/testing/nmapscans
echo

# Nmap bootstrap file checker
NB=nmap-bootstrap.xsl
if [ -f $NB ]
then
    echo "Found nmap-bootstrap.xsl"

else

    echo -e "\e[034mDownloading Missing $BOOTSTRAP File\e[0m"
wget -O /home/kali/Desktop/testing/nmapscans/nmap-bootstrap.xsl https://raw.githubusercontent.com/aryanguenthner/nmap-bootstrap-xsl/stable/nmap-bootstrap.xsl > /dev/null

fi
echo

# apt update
# apt -y install balena-etcher-electron
# Download and Install Etcher - USB Bootable Media Creator
# curl -1sLf \
#   'https://dl.cloudsmith.io/public/balena/etcher/setup.deb.sh' \
#   | sudo -E bash 

# Project Discovery Install go
sudo apt -y install golang-go
go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
echo
pip install --upgrade pip
echo
python3 -m pip install -U pip
pip3 install --upgrade setuptools

# Updog works on python 3.9 not 3.10
# echo "Installing Updog"
# pip3 install updog

echo "Installing psycopg"
pip install psycopg
echo

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

# Works with Python 3.9
echo "Hacker TV"
sudo apt-get -y install python3-imdbpy libmpv1 gir1.2-xapp-1.0 debhelper python3-setproctitle dpkg-dev
cd /opt
sudo git clone https://github.com/aryanguenthner/hypnotix.git
cd hypnotix
sudo apt-get install -y python3.10-venv
wget http://ftp.us.debian.org/debian/pool/main/i/imdbpy/python3-imdbpy_6.8-2_all.deb &&
sudo dpkg -i python3-imdbpy_6.8-2_all.deb
sudo dpkg-buildpackage -b -uc
sudo python3 -m venv ./venv
sudo dpkg -i hypnotix*.deb
echo

# Signal
# NOTE: These instructions only work for 64 bit Debian-based Kali Linux
# Linux distributions such as Ubuntu, Mint etc.
# 1. Install our official public software signing key
wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg
cat signal-desktop-keyring.gpg | sudo tee -a /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null
# 2. Add our repository to your list of repositories
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |\
sudo tee -a /etc/apt/sources.list.d/signal-xenial.list
# 3. Update your package database and install signal
sudo apt-get update && apt-get -y install signal-desktop
echo

echo "VPN stuff"
cd /tmp
wget --no-check-certificate https://swupdate.openvpn.net/repos/openvpn-repo-pkg-key.pub
apt-key add openvpn-repo-pkg-key.pub
echo

echo "Getting tmpmail"
# Hackers like tmpmail
# tmpmail --generate hackermaill@1secmail.com
curl -L "https://git.io/tmpmail" > tmpmail && chmod +x tmpmail
mv tmpmail ~/bin/
./tmpmail --generate
echo

# Hackers like SSH
echo
echo "Enabling SSH"
sed -i '33s/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
sudo systemctl enable ssh
sudo service ssh restart
echo

# Metasploit Setup
mkdir -p /opt/metasploit
cd /opt/metasploit
curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && chmod 755 msfinstall && ./msfinstall
echo

echo "Metasploit Ready Up"
echo
systemctl start postgresql
msfdb init
echo
# Yeet
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
''' echo "RDPY"
echo
cd /opt
git clone https://github.com/citronneur/rdpy.git
cd rdpy
sudo python setup.py install
echo
echo "EyeWitness"
echo
cd /opt
git clone https://github.com/FortyNorthSecurity/EyeWitness.git
cd /opt/EyeWitness/Python/setup
sudo yes | ./setup.sh
'''
# TODO get gowitness
echo
echo "Cewl"
echo
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
echo
cd /opt
git clone https://github.com/sense-of-security/ADRecon.git
echo

echo "enum4linux-ng"
echo
cd /opt
git clone https://github.com/cddmp/enum4linux-ng.git
echo

echo "BloodHound"
echo

cd /opt
git clone https://github.com/BloodHoundAD/Bloodhound.git
echo

echo "bloodhound-python"
echo
# bloodhound-python -u 'bob' -p 'Passw0rd!' -ns 192.168.1.3 -d LAB.local  -c all'
sudo pip install bloodhound
echo

echo "Daniel Miessler Security List Collection"
cd /opt
git clone https://github.com/danielmiessler/SecLists.git
cd SecLists
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

echo "OneListForAll"
cd /opt
git clone https://github.com/six2dez/OneListForAll.git
cd OneListForAll
# 7z x onelistforall.7z.001
wget https://raw.githubusercontent.com/NotSoSecure/password_cracking_rules/master/OneRuleToRuleThemAll.rule
wget https://github.com/NotSoSecure/password_cracking_rules/blob/master/OneRuleToRuleThemAll.rule
wget https://contest-2010.korelogic.com/rules.txt
cat rules.txt >> /etc/john/john.conf
echo

echo "SprayingToolKit"
cd /opt
git clone https://github.com/byt3bl33d3r/SprayingToolkit.git
: ' Nmap works dont forget --> nmap -Pn -p 445 -script smb-brute --script-args='smbpassword=Summer2019,smbusername=Administrator' 192.168.1.23 '
echo
: ' Hydra works dont forget --> hydra -p Summer2019 -l Administrator smb://192.168.1.23 '
: ' Metasploit works dont forget --> set smbpass Summer2019 / set smbuser Administrator / set rhosts 192.168.1.251 / run '

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
echo
cd /opt
git clone https://github.com/awslabs/git-secrets.git
echo

echo "Git Leaks"
echo
cd /opt
git clone https://github.com/zricethezav/gitleaks.git
echo

echo "Discover Admin Loging Pages - Breacher"
echo
cd /opt
git clone https://github.com/s0md3v/Breacher.git
echo

echo "Search Google Extract Result URLS - degoogle"
echo
cd /opt
git clone https://github.com/deepseagirl/degoogle.git
echo

echo "Web SSH (Pretty Cool)"
echo
cd /opt
git clone https://github.com/huashengdun/webssh.git
echo

echo "Installing Impacket"
echo
cd /opt
sudo pip3 install jinja2==2.10.1
git clone https://github.com/SecureAuthCorp/impacket.git
cd /opt
cd impacket
pip3 install -e .
echo

echo "The devils eye"
pip install thedevilseye
# eye -q "hacker tools" | grep .onion > hackertoolse+onions.txt
echo
echo "GitRob"
cd /tmp
sudo wget --no-check-certificate https://github.com/michenriksen/gitrob/releases/download/v2.0.0-beta/gitrob_linux_amd64_2.0.0-beta.zip
unzip gitrob_linux_amd64_2.0.0-beta.zip
mkdir -p /opt/gitrob
mv gitrob /opt/gitrob/
echo

# echo "Google Play CLI" I wish this one actually worked
# apt -y install gplaycli
echo
# Save these two for later
# git clone https://github.com/jschicht/RawCopy.git
# git clone https://github.com/khr0x40sh/MacroShop.git

echo
echo "OSINT Phone Number Info Gathering Tool"
cd /opt
git clone https://github.com/sundowndev/PhoneInfoga.git
cd PhoneInfoga
curl -sSL https://raw.githubusercontent.com/sundowndev/PhoneInfoga/master/support/scripts/install | bash\n
./phoneinfoga version
echo

echo "Hacker Hacker"
cd /opt
git clone https://github.com/aryanguenthner/365.git
cd 365
sudo dos2unix *.sh *.py && chmod +x *.sh *.py && chmod -R 777 .
echo

# Tor Web Browser Stuff
echo
# sudo gpg --keyserver pool.sks-keyservers.net --recv-keys EB774491D9FF06E2 && 
sudo apt -y install torbrowser-launcher
cd /opt
git clone https://github.com/aryanguenthner/TorGhost.git
cd TorGhost
sudo apt -y install python3-pyinstaller
sudo apt -y install python3-notify2
sudo pip3 install . --ignore-installed stem
sudo ./build.sh
echo

# MongoDB Install
echo
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

# Install Ivre.Rocks
echo
sudo apt -y install ivre
echo

# Ivre Dependencies
sudo pip install tinydb
sudo pip install py2neo
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
cp /usr/share/ivre/nmap_scripts/*.nse /usr/share/nmap/scripts/
yes | patch /usr/share/nmap/scripts/rtsp-url-brute.nse \
/usr/share/ivre/nmap_scripts/patches/rtsp-url-brute.patch
nmap --script-updatedb > /dev/null
echo

# http-screenshot Checker
N=/usr/share/nmap/scripts/http-screenshot.nse

if [ -f $N ]
then
    echo "Found http-screenshot.nse"

else

    echo "Downloading missing file http-screenshot.nse"
cd /usr/share/nmap/scripts
wget https://raw.githubusercontent.com/ivre/ivre/master/patches/nmap/scripts/http-screenshot.nse > /dev/null
nmap --script-updatedb > /dev/null

fi

# PhantomJS Checker
P=`phantomjs -v`
if [ "$P" = "1.9.8" ]
then
    echo "Found PhantomJS 1.9.8"

else

    echo -e "\e[034mDownloading Missing PhantomJS\e[0m"

wget -O /tmp/phantomjs-1.9.8-linux-x86_64.tar.bz2 https://github.com/aryanguenthner/365/blob/f5a069eec95557f2741c16d0dbf27653ddb85e25/phantomjs-1.9.8-linux-x86_64.tar.bz2

echo "Extracting and Installing PhantomJS 1.9.8"
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
# cd /opt/gowitness
# ./gowitness-2.4.2-linux-amd64 file -f url-results.txt
# "View Report http://localhost:7171"
# ./gowitness-2.4.2-linux-amd64 server report
GWIT=/opt/gowitness/gowitness-2.4.2-linux-amd64
if [ -f $GWIT ]
then
    echo "Found gowitness-2.4.2-linux-amd64"

else

    echo -e "\e[034mDownloading Missing $GWIT File\e[0m"
cd /opt
mkdir -p /opt/gowitness
wget -O $PWD/gowitness-2.4.2-linux-amd64 https://github.com/aryanguenthner/gowitness/releases/download/gowitness/gowitness-2.4.2-linux-amd64

fi
echo

# Windows Exploit Suggester Next Gen
echo
cd /opt
sudo git clone https://github.com/bitsadmin/wesng.git
echo

# MobSF Setup
echo
# nano -c /opt/Mobile-Security-Framework-MobSF/run.sh
# MobSF working with Python 3.7/3.8
#sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1
#sudo update-alternatives --set python3 /usr/bin/python3.8/
echo

# Fix permissions
sudo chmod -R 777 /home/kali/
echo
echo "Hacker Hacker"
echo
systemctl restart ntp
source ~/.zshrc
echo

# Bare metal Kali install or Virtual Machine install
# https://www.kali.org/docs/virtualization/install-virtualbox-host/
# https://wiki.debian.org/VirtualBox
echo "Are you installing a Kali Virtual Machine? "
echo "Enter y/n: "
read answer
echo

if [ $answer == "y" ]
then

    echo "Good Choice"

else

    echo "Bare Metal installling Vbox"

sudo wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
sudo wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
sudo echo "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian buster contrib" >> /etc/apt/sources.list
sudo apt update
sudo apt -y install linux-headers-`uname -r` build-essential virtualbox-guest-utils virtualbox-dkms dkms virtualbox virtualbox-ext-pack
echo
# VirtualBox Hack for USB Devices
sudo usermod -a -G vboxusers $USER
echo
sudo apt --fix-broken install
sudo apt autoremove -y
updatedb
fi
echo

echo
# Customize Kali
echo 'hostname -I' >> /root/.zshrc
echo 'export GOPATH=$HOME/work' >> /root/.zshrc
echo 'export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin' >> /root/.zshrc
echo 'export PATH=$HISTCONTROL=ignoredups' >> /root/.zshrc
# Go Fix Go
echo 'export GOPATH=$HOME/go' >> /root/.zshrc
echo 'export PATH=$PATH:$GOROOT/bin:$GOPATH/bin' >> /root/.zshrc
# MobSF
echo 'export PATH=$ANDROID_SDK=/root/Android/Sdk/:$PATH' >> /root/.zshrc
echo 'export PATH=$ANDROID_SDK/emulator:$ANDROID_SDK/tools:$PATH' >> /root/.zshrc
echo 'export PATH=/root/Android/Sdk/platform-tools:$PATH' >> /root/.zshrc
echo 'export PATH=/opt/android-studio/jre/jre/bin:$PATH' >> /root/.zshrc
# Java Deez Nutz
echo 'export PATH=$JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64:$PATH' >> /root/.zshrc
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> /root/.zshrc
# Arachni
echo 'export PATH=$arachni_dir=/opt/arachni/bin:$PATH' >> /root/.zshrc
# Other
echo 'export PATH=$PATH:/snap/bin:$PATH' >> /root/.zshrc
echo 'export PATH=$GOPATH=$HOME/work' >> /root/.zshrc
echo 'export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin' >> /root/.zshrc
echo 'export PATH=$ANDROID_SDK=/root/Android/Sdk/' >> /root/.zshrc
echo 'export PATH=$ANDROID_SDK/emulator:$ANDROID_SDK/tools' >> /root/.zshrc
echo 'export PATH=$PATH/root/Android/Sdk/platform-tools' >> /root/.zshrc
echo 'export PATH=$PATH/opt/android-studio/jre/jre/bin/' >> /root/.zshrc
echo 'export PATH=$JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/' >> /root/.zshrc
echo 'export PATH=/usr/bin:/usr/bin:=/usr/lib/jvm/java-11-openjdk-amd64/:/snap/bin/' >> /root/.zshrc
echo 'export PATH=/usr/sbin:/usr/bin:=/usr/lib/jvm/java-11-openjdk-amd64/:/snap/bin/' >> /root/.zshrc
echo 'export PATH=/usr/local/bin:$PATH' >> /root/.zshrc
echo

: ' # Mobile Security Assessment Tool MobSF
cd /opt/
git clone https://github.com/MobSF/Mobile-Security-Framework-MobSF.git
cd Mobile-Security-Framework-MobSF/
pip3 install -r requirements.txt
python3 -m venv ./venv
./setup.sh
echo
'
sudo pip3 install --upgrade requests
date | tee kali-setup-finish-date.txt
# TODO: Add this to VLC https://broadcastify.cdnstream1.com/24051
reboot
# Just in case DNS issues: nano -c /etc/resolvconf/resolv.conf.d/head
# Taco Taco
# Gucci
