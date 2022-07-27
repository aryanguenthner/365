################################################
# Kali Linux Post Setup Automation Script VirtualBox
# Tested on Kali 2022.4
# If you're reading this pat yourself on the back
# sudo dos2unix *.sh
# sudo chmod +x *.sh
# Usage: cd /opt/365
# chmod +x *.sh *.py
# chmod -R 777 .
# sudo ./kali-setup.sh | tee kali.log
# Learn more at https://github.com/aryanguenthner/
# Last Updated 07/27/2022, Minor updates
################################################
echo
cd /tmp
date > kali-setup-date.txt
echo
echo "Good Idea to Update and Upgrade first before we do this kali-setup.sh"
echo
apt update && apt -y upgrade && apt -y full-upgrade && updatedb && apt autoclean && reboot
echo
echo "Be Patient, Installing Kali Dependencies"
echo
apt update
apt -y install gconf-service gconf2-common libc++1 libc++1-13 libc++abi1-13 libgconf-2-4 libunwind-13 sendmail libgl1-mesa-glx libegl1-mesa libxcb-xtest0 ibus feroxbuster virtualenv mailutils mpack ndiff docker docker.io docker-compose containerd python3.9-venv python3-dev python3-venv pip python3-pip python3-bottle python3-cryptography python3-dbus python3-future python3-matplotlib python3-mysqldb python3-openssl python3-pil python3-psycopg2 python3-pymongo python3-sqlalchemy python3-tinydb python3-py2neo at bloodhound ipcalc nload crackmapexec hostapd dnsmasq gedit cupp nautilus dsniff build-essential cifs-utils cmake curl ffmpeg gimp git graphviz imagemagick libapache2-mod-php php-xml libmbim-utils nfs-common openssl tesseract-ocr vlc wkhtmltopdf xsltproc xutils-dev driftnet websploit apt-transport-https openresolv screenfetch baobab speedtest-cli libffi-dev libssl-dev libxml2-dev libxslt1-dev zlib1g-dev awscli sublist3r w3m jq hplip printer-driver-hpcups cups system-config-printer gobuster tcpxtract libreoffice
echo
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
# echo
# Download and Install cloudflare tunnel
cd /tmp
wget https://github.com/aryanguenthner/365/blob/master/cloudflared-linux-amd64.deb
dpkg -i cloudflared-linux-amd64.deb
# python3 -m http.server 443
# cloudflared tunnel --url localhost:443

echo
cd /usr/share/nmap/scripts
wget https://raw.githubusercontent.com/aryanguenthner/nmap-nse-vulnerability-scripts/master/smtp-vuln-cve2020-28017-through-28026-21nails.nse
nmap --script-updatedb > /dev/null
echo
# Nmap Testing
mkdir -p /home/kali/Desktop/testing/nmapscans
cd /home/kali/
chmod -R 777 .
echo
# Nmap bootstrap file checker
# If file exists skip the download
# if file is missing download it
N='nmap-bootstrap.xsl'
echo "Nmap Bootstrap File Checker"
echo
if [ -f $N ]
then
    echo "File Found: nmap-bootstrap.xsl"

else

    echo "Downloading Missing File"
    wget https://raw.githubusercontent.com/aryanguenthner/nmap-bootstrap-xsl/stable/nmap-bootstrap.xsl

fi
cp nmap-bootstrap.xsl /home/kali/Desktop/testing/nmapscans
echo
# Download and Install Etcher - USB Bootable Media Creator
# curl -1sLf \
#   'https://dl.cloudsmith.io/public/balena/etcher/setup.deb.sh' \
#   | sudo -E bash 
echo
# apt update
# apt -y install balena-etcher-electron
echo
# Project Discovery Install go
sudo apt -y install golang-go
echo
go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
echo
pip install --upgrade pip
python3 -m pip install -U pip
pip3 install --upgrade setuptools
echo "Installing Updog"
pip3 install updog
echo "Installing psycopg"
pip install psycopg
echo
# How to Update Python Alternatives
echo
''' # kali python Config
sudo update-alternatives --list python
sudo update-alternatives --config python
sudo update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.9 3
sudo update-alternatives --set python /usr/bin/python3.9
# update-alternatives --remove-all python

#kali python3 Config
sudo update-alternatives --list python3
sudo update-alternatives --config python3
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 2
sudo update-alternatives --set python3 /usr/bin/python3.9
'''
echo
# Works with Python 3.9
echo "Hacker TV"
echo
sudo apt -y install python3-imdbpy
echo
sudo apt -y install libmpv1 gir1.2-xapp-1.0 debhelper python3-setproctitle dpkg-dev git
echo
cd /opt
sudo git clone https://github.com/aryanguenthner/hypnotix.git
cd hypnotix
wget http://ftp.us.debian.org/debian/pool/main/i/imdbpy/python3-imdbpy_6.8-2_all.deb &&
sudo dpkg -i python3-imdbpy_6.8-2_all.deb
sudo dpkg-buildpackage -b -uc
sudo python3 -m venv ./venv
sudo dpkg -i hypnotix*.deb
echo
# Signal
echo
# NOTE: These instructions only work for 64 bit Debian-based Kali Linux
# Linux distributions such as Ubuntu, Mint etc.
# 1. Install our official public software signing key
wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg
cat signal-desktop-keyring.gpg | sudo tee -a /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null
# 2. Add our repository to your list of repositories
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |\
sudo tee -a /etc/apt/sources.list.d/signal-xenial.list
# 3. Update your package database and install signal
sudo apt update && apt -y install signal-desktop
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
echo "Your Internal IP Address"
hostname -I
echo
echo "External Internal IP Address"
sudo curl ifconfig.me
echo
echo '# IP Address' >> /root/.zshrc
echo 'hostname -I' >> /root/.zshrc
echo
echo '# Go' >> /root/.zshrc
echo 'export GOPATH=$HOME/work' >> /root/.zshrc
echo 'export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin' >> /root/.zshrc
echo 'export HISTCONTROL=ignoredups' >> /root/.zshrc
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
echo
cd /opt
echo "Kingfisher"
echo
cd /opt
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
echo "Phone Info Gathering Tool"
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
sudo dos2unix *.sh *.py && chmod +x *.sh *.py
echo
# Tor Web Browser Stuff
echo
# sudo gpg --keyserver pool.sks-keyservers.net --recv-keys EB774491D9FF06E2 && 
sudo apt -y install torbrowser-launcher
echo
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
# Dependencies
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
# Nmap Magic
echo
echo "Copying IVRE Nmap Scripts to Nmap"
echo
cp /usr/share/ivre/nmap_scripts/*.nse /usr/share/nmap/scripts/
yes | patch /usr/share/nmap/scripts/rtsp-url-brute.nse \
/usr/share/ivre/nmap_scripts/patches/rtsp-url-brute.patch
nmap --script-updatedb > /dev/null
echo
echo "Got Nmap http-screenshot script?"
N='/usr/share/nmap/scripts/http-screenshot.nse'
if [ -f $N ]
then
   echo "File found: http-screenshot.nse"

ls -l /usr/share/nmap/scripts/http-screenshot.nse
else
    echo "Downloading missing file http-screenshot.nse"
cd /usr/share/nmap/scripts
wget https://raw.githubusercontent.com/ivre/ivre/master/patches/nmap/scripts/http-screenshot.nse
fi
nmap --script-updatedb >/dev/null
echo
# Enable Nmap to get Screenshots using Phantomjs v1.9.8
echo
# PhantomJS Checker
# Used for nmap screenshots
# PhantomJS Checker
# Used for nmap screenshots
echo "PhantomJS Checker"
P=`phantomjs -v`
echo
if [ $P=1.9.8 ]
then
    echo "Found PhantomJS"

phantomjs -v
else
    echo "Downloading PhantomJS"
cd /tmp
echo
wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.8-linux-x86_64.tar.bz2
echo
echo "Extracting and Installing PhantomJS 1.9.8"
tar xvf phantomjs-1.9.8-linux-x86_64.tar.bz2
mv phantomjs-1.9.8-linux-x86_64 phantomjs
mv phantomjs /opt
ln -s /opt/phantomjs/bin/phantomjs /usr/local/bin/phantomjs
phantomjs -v

fi
echo
# Windows Exploit Suggester Next Gen
echo
cd /opt
sudo git clone https://github.com/bitsadmin/wesng.git
echo
# MobSF Setup
echo
echo "Installing MobSF on kali 2020.4"
# nano -c /opt/Mobile-Security-Framework-MobSF/run.sh
# MobSF working with Python 3.7/3.8
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1
sudo update-alternatives --set python3 /usr/bin/python3.8/
echo
cd /opt/
git clone https://github.com/MobSF/Mobile-Security-Framework-MobSF.git
cd Mobile-Security-Framework-MobSF/
pip3 install -r requirements.txt
python3 -m venv ./venv
./setup.sh
echo
# Go Fix Go
echo export GOPATH=$HOME/go >> /root/.zshrc
echo export PATH=$PATH:$GOROOT/bin:$GOPATH/bin >> /root/.zshrc
# MobSF
echo export PATH=$ANDROID_SDK=/root/Android/Sdk/:$PATH >> /root/.zshrc
echo export PATH=$ANDROID_SDK/emulator:$ANDROID_SDK/tools:$PATH >> /root/.zshrc
echo export PATH=/root/Android/Sdk/platform-tools:$PATH >> /root/.zshrc
echo export PATH=/opt/android-studio/jre/jre/bin:$PATH >> /root/.zshrc
# Java Deez Nutz
echo export PATH=$JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64:$PATH >> /root/.zshrc
echo export PATH=$JAVA_HOME/bin:$PATH >> /root/.zshrc
# Arachni
echo export PATH=$arachni_dir=/opt/arachni/bin:$PATH >> /root/.zshrc
# Others
echo export PATH=$PATH:/snap/bin:$PATH >> /root/.zshrc
echo export PATH=$PATH:/snap/bin >> /root/.zshrc
echo export PATH=$GOPATH=$HOME/work >> /root/.zshrc
echo export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin >> /root/.zshrc
echo export PATH=$HISTCONTROL=ignoredups >> /root/.zshrc
echo export PATH=$ANDROID_SDK=/root/Android/Sdk/ >> /root/.zshrc
echo export PATH=$ANDROID_SDK/emulator:$ANDROID_SDK/tools >> /root/.zshrc
echo export PATH=$PATH/root/Android/Sdk/platform-tools >> /root/.zshrc
echo export PATH=$PATH/opt/android-studio/jre/jre/bin/ >> /root/.zshrc
echo export PATH=$JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/ >> /root/.zshrc
echo export PATH=$PATH:/snap/bin/ >> /root/.zshrc
echo export PATH=/usr/bin:/usr/bin:=/usr/lib/jvm/java-11-openjdk-amd64/:/snap/bin/ >> /root/.zshrc
echo export PATH=/usr/sbin:/usr/bin:=/usr/lib/jvm/java-11-openjdk-amd64/:/snap/bin/ >> /root/.zshrc
echo export PATH=/usr/local/bin:$PATH >> /root/.zshrc
echo
sudo chmod -R 777 /home/kali/
echo
echo "Hacker Hacker"
echo
systemctl restart ntp
source ~/.zshrc
echo
# Virtualbox Install if your doing a hard install
# https://www.kali.org/docs/virtualization/install-virtualbox-host/
# https://wiki.debian.org/VirtualBox
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
echo
date > kali-setup-finish-date.txt
# Potential temporary fix apt key warning when you update
# mv /etc/apt/trusted.gpg /etc/apt/trusted.gpg.d/
# TODO: Add this to VLC https://broadcastify.cdnstream1.com/24051
reboot
# Just in case DNS issues: nano -c /etc/resolvconf/resolv.conf.d/head
# Taco Taco
# Gucci
