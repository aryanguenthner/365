#!/bin/bash
################################################
# Kali Post Setup Automation Script with ivre.rocks
# Tested on Kali 2020.4
# If you're reading this pat yourself on the back
# sudo dos2unix *.sh
# sudo chmod +x *.sh
# Usage: sudo ./kali-setup.sh | tee setup.log
# Learn more at https://github.com/aryanguenthner/
# Last Updated 12/21/2020
################################################

date > kali-setup-date.txt

echo "Let's update first before we do this"

# apt update && sudo apt -y upgrade && sudo apt -y full-upgrade && reboot

echo "Be Patient, Installing Kali Dependencies"

sudo apt -y install python3-dev python3-venv python3.8-venv pip python3-pip python3-bottle python3-cryptography python3-dbus python3-future python3-matplotlib python3-mysqldb python3-openssl python3-pil python3-psycopg2 python3-pymongo python3-sqlalchemy python3-tinydb python3-py2neo openjdk-11-jdk crackmapexec hostapd dnsmasq gedit cupp nautilus dsniff build-essential cifs-utils cmake curl ffmpeg gimp git graphviz imagemagick libapache2-mod-php php-xml libappindicator3-1 libindicator3-7 libmbim-utils nfs-common openssl terminator tesseract-ocr vlc wkhtmltopdf xsltproc xutils-dev driftnet websploit apt-transport-https openresolv screenfetch baobab speedtest-cli sendmail libffi-dev libssl-dev libxml2-dev libxslt1-dev zlib1g-dev awscli sublist3r w3m jq libreoffice

pip3 install --upgrade pip

# Update Python Alternatives

: 'kali python Config
sudo update-alternatives --list python
sudo update-alternatives --config python
sudo update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.8 3
sudo update-alternatives --set python /usr/bin/python3.8
# update-alternatives --remove-all python

kali python3 Config
update-alternatives --list python3
sudo update-alternatives --config python3
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 2 #hypnotix, apt work, not MobSF
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 3 #MobSF
sudo update-alternatives --set python3 /usr/bin/python3.9
'
echo "VPN stuff"
cd /tmp
wget --no-check-certificate https://swupdate.openvpn.net/repos/openvpn-repo-pkg-key.pub
apt-key add openvpn-repo-pkg-key.pub

echo "Getting tmpmail"
# Hackers like tmpmail
# tmpmail --generate hackermaill@1secmail.com
curl -L "https://git.io/tmpmail" > tmpmail && chmod +x tmpmail
mv tmpmail ~/bin/

# Hackers like SSH

echo "Enabling SSH"
sudo sed -i '32s/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sudo systemctl enable ssh
sudo service ssh restart

# Share your Kali Terminal: teleconsole -f localhost:5555

echo "Teleconsole is Awesome"
curl https://www.teleconsole.com/get.sh | sh

echo "Your Internal IP Address"
hostname -I

echo "External Internal IP Address"
curl ifconfig.me

echo '# IP Address' >> /root/.bashrc
echo 'hostname -I' >> /root/.bashrc

echo '# Go' >> /root/.bashrc
echo 'export GOPATH=$HOME/work' >> /root/.bashrc
echo 'export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin' >> /root/.bashrc

# Metasploit Setup
cd /opt
sudo curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && chmod 755 msfinstall && ./msfinstall

echo "Metasploit Ready Up"
sudo systemctl start postgresql
sudo msfdb init

# Yeet

cd /opt
echo "ShellPhish"
cd /opt
git clone https://github.com/aryanguenthner/shellphish.git
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
sudo python setup.py install
echo
echo "Subbrute"
cd /opt
git clone https://github.com/TheRook/subbrute.git
echo
echo "dnstwister"
cd /opt
git clone https://github.com/elceef/dnstwist.git
sudo apt-get -y install python3-dnspython python3-geoip python3-whois python3-requests python3-ssdeep python3-dns
echo
echo "RDPY"
cd /opt
git clone https://github.com/citronneur/rdpy.git
cd rdpy
sudo python setup.py install
echo "EyeWitness"
cd /opt
git clone https://github.com/FortyNorthSecurity/EyeWitness.git
cd /opt/EyeWitness/Python/setup
sudo yes | ./setup.sh
echo
echo
echo "Cewl"
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
echo "bloodhound-python"
# bloodhound-python -u 'bob' -p 'Passw0rd!' -ns 192.168.1.3 -d LAB.local  -c all'
pip install bloodhound
echo
echo "Daniel Miessler Security List Collection"
cd /opt
git clone https://github.com/danielmiessler/SecLists.git
cd SecLists
echo "Downloading OneRuleToRuleThemAll"
wget https://github.com/NotSoSecure/password_cracking_rules/blob/master/OneRuleToRuleThemAll.rule
echo
echo "Awesome Incident Response"
cd /opt
git clone https://github.com/meirwah/awesome-incident-response.git

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
echo
echo "SprayingToolKit"
cd /opt
git clone https://github.com/byt3bl33d3r/SprayingToolkit.git
: ' Nmap works dont forget --> nmap -Pn -p 445 -script smb-brute --script-args='smbpassword=Summer2019,smbusername=Administrator' 192.168.1.23 '
echo
: ' Hydra works dont forget --> hydra -p Summer2019 -l Administrator smb://192.168.1.23 '
: ' Metasploit works dont forget --> set smbpass Summer2019 / set smbuser Administrator / set rhosts 192.168.1.251 / run '
echo
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
echo
echo "Discover Admin Loging Pages - Breacher"
cd /opt
git clone https://github.com/s0md3v/Breacher.git
echo
echo "Search Google Extract Result URLS - degoogle"
cd /opt
git clone https://github.com/deepseagirl/degoogle.git
echo
echo "Web SSH (Pretty Cool)"
cd /opt
git clone https://github.com/huashengdun/webssh.git
echo
echo "Installing Impacket"
pip install jinja2==2.10.1
cd /opt
git clone https://github.com/SecureAuthCorp/impacket.git
cd /opt
cd impacket
sudo python setup.py install

echo "GitRob"
cd /tmp
sudo wget --no-check-certificate https://github.com/michenriksen/gitrob/releases/download/v2.0.0-beta/gitrob_linux_amd64_2.0.0-beta.zip
unzip gitrob_linux_amd64_2.0.0-beta.zip
mkdir -p /opt/gitrob
mv gitrob /opt/gitrob/
echo
#echo "Google Play CLI"
#apt -y install gplaycli
echo
echo "Lee Baird Discover Script"
cd /opt
git clone https://github.com/leebaird/discover.git
echo "Just Don't Update Kali Using the Lee Baird Discover Update Script"
echo
# Save these two for later
# git clone https://github.com/jschicht/RawCopy.git
# git clone https://github.com/khr0x40sh/MacroShop.git

echo "Hacker Hacker"
cd /opt
git clone https://github.com/aryanguenthner/365.git
cd 365
dos2unix *.sh *.py && chmod +x *.sh *.py
echo

#Tor Web Browser Stuff

#sudo gpg --keyserver pool.sks-keyservers.net --recv-keys EB774491D9FF06E2 && 
sudo apt -y install torbrowser-launcher

cd /opt
git clone https://github.com/aryanguenthner/TorGhost.git
cd TorGhost
sudo apt -y install python3-pyinstaller
sudo apt -y install python3-notify2
sudo pip3 install --ignore-installed stem
sudo ./build.sh

# MongoDB Install

echo "Installing MongoDB 4.2 from Ubuntu Repo, Because It Works"

cd /tmp
wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | apt-key add -
echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.2.list
apt update
apt -y install mongodb-org
service mongod start
systemctl enable mongod.service
echo "Hopefully MongoDB Installed without any issivreues"
echo

# Install Ivre Dependencies

echo "Attepting To Installing Some IVRE Dependencies"
sudo apt -y install python3-bottle python3-cryptography python3-dbus python3-future python3-matplotlib python3-mysqldb python3-openssl python3-pil python3-psycopg2 python3-pymongo python3-sqlalchemy python3-tinydb python3-py2neo

# Install Ivre.Rocks
echo
apt -y install ivre
echo

# Nmap Magic

echo "Copying IVRE Nmap Scripts to Nmap"
sudo apt -y install nmap

cp /usr/local/share/ivre/nmap_scripts/*.nse /usr/share/nmap/scripts/
patch /usr/share/nmap/scripts/rtsp-url-brute.nse \
/usr/local/share/ivre/nmap_scripts/patches/rtsp-url-brute.patch
nmap --script-updatedb

# Enable Nmap Screenshots

cd /opt
wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.8-linux-x86_64.tar.bz2
tar xvf phantomjs-1.9.8-linux-x86_64.tar.bz2
mv phantomjs-1.9.8-linux-x86_64 phantomjs
mv phantomjs /opt
ln -s /opt/phantomjs/bin/phantomjs /usr/local/bin/phantomjs
phantomjs -v

# Ivre Database init, data download & importation

echo -e '\r'
yes | ivre ipinfo --init # Run to Clear Dashboard
yes | ivre scancli --init #Run to Clear Dashboard
yes | ivre view --init #Run to Clear Dashboard
yes | ivre flowcli --init
yes | ivre runscansagentdb --init
sudo ivre ipdata --download
echo -e '\r'

echo "Hacker TV"

apt -y install libmpv1 gir1.2-xapp-1.0 debhelper python3-setproctitle dpkg-dev git
echo
cd /opt
sudo git clone https://github.com/linuxmint/hypnotix.git
cd hypnotix
wget http://ftp.us.debian.org/debian/pool/main/i/imdbpy/python3-imdbpy_6.8-2_all.deb &&
sudo dpkg -i python3-imdbpy_6.8-2_all.deb 
sudo dpkg-buildpackage -b -uc
sudo dpkg -i ../hypnotix*.deb

# Windows Exploit Suggester Next Gen

cd /opt
sudo git clone https://github.com/bitsadmin/wesng.git

# MobSF Setup

echo '# MobSF' >> /root/.bashrc
export ANDROID_SDK=/root/Android/Sdk/
export PATH=$ANDROID_SDK/emulator:$ANDROID_SDK/tools:$PATH
export PATH="/root/Android/Sdk/platform-tools":$PATH
export PATH="/opt/android-studio/jre/jre/bin":$PATH

echo '# Java Deez Nutz' >> /root/.bashrc
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH

echo "Installing MobSF on kali 2020.4"
# Works with Python 3.7/3.8

cd /opt/
sudo git clone https://github.com/MobSF/Mobile-Security-Framework-MobSF.git
cd Mobile-Security-Framework-MobSF/
sudo pip3 install -r requirements.txt
sudo supython3 -m venv ./venv
sudo ./setup.sh

sudo chmod -R 777 /home/kali/

echo "Hacker Hacker"
sudo systemctl restart ntp
source ~/.bashrc
source ~/.zshrc

updatedb
reboot
