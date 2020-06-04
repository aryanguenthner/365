#!/bin/bash
################################################
# Kali Post Setup Automation Script
# Tested on Kali 2020.2
# If you're reading this pat yourself on the back
# sudo dos2unix kali-setup.sh
# sudo chmod +x kali-setup.sh 
# Usage type: sudo ./kali-setup.sh | tee setuplog.txt
# Learn more at https://github.com/aryanguenthner/
# Last Updated 2020-06-04
################################################
#python-pygraphviz python-psycopg2 python-krbv python-mysqldb <-- //Might need these
echo
cd /home/kali/Desktop
echo "Did you update your Kali before running this script?"
echo
date 2>&1 | tee kali-setup-startdate.txt
echo
# Because We like SSH
echo "Enabling SSH"
sed -i '32s/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
systemctl enable ssh
service ssh restart
echo
echo "Kali IP Address"
hostname -I
echo
echo '# Kali IP' >> /root/.bashrc
echo 'hostname -I' >> /root/.bashrc
echo
echo "Attempting to Disable IPv6" # We will be back here
echo 'net.ipv6.conf.disable_ipv6 = 1' >> /etc/sysctl.conf
echo 'net.ipv6.conf.eth0.disable_ipv6 = 1' >> /etc/sysctl.conf
echo 'net.ipv6.conf.wlan0.disable_ipv6 = 1' >> /etc/sysctl.conf
echo 'net.ipv6.conf.wlan1.disable_ipv6 = 1' >> /etc/sysctl.conf
sysctl -p -f /etc/sysctl.conf
echo "Be Patient, Installing Kali Dependencies"
apt -y install python-crypto hostapd dnsmasq gedit cupp nautilus dsniff build-essential cifs-utils cmake curl ffmpeg gimp git graphviz imagemagick libapache2-mod-php php-xml libappindicator3-1 libindicator3-7 libmbim-utils libreoffice nfs-common openssl phantomjs python3-dev python-dbus python-lxml python-pil terminator tesseract-ocr vlc wkhtmltopdf xsltproc xutils-dev python3-venv
echo
echo "Metasploit Ready Up"
msfdb init
systemctl start postgresql
echo
echo "IVRE Rocks"
sudo apt-get -y install ivre
echo
echo "Getting Vulsec & Vulners to make Nmap Do cool things"
cd /usr/share/nmap/scripts/
git clone https://github.com/vulnersCom/nmap-vulners.git
git clone https://github.com/scipag/vulscan.git
cd vulscan/utilities/updater/
chmod +x updateFiles.sh
./updateFiles.sh
echo
# Yeat
echo "Fixing setoolkit"
# Fix Social Engineer Toolkit
# Remove old files
rm -R /usr/share/set
# Get the lastest files
git clone https://github.com/trustedsec/social-engineer-toolkit.git
# Rename
mv social-engineer-toolkit set
# Move the new files back to the correct path
mv set /usr/share
#Edit line 144 to enable hotkey to Show Desktop xfce
#/home/kali/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml
#      <property name="&lt;Super&gt;d" type="string" value="show_desktop_key"/>
echo "Cloud Tool Time"
# Rename
# Get Pip
# Cloudsecurity Tool Time
# https://rhinosecuritylabs.com/aws/pacu-open-source-aws-exploitation-framework/
echo "Pacu The Fish, Not the Rapper"
sudo apt-get remove python3-pip; sudo apt-get install python3-pip
cd /opt
git clone https://github.com/RhinoSecurityLabs/pacu
cd pacu
bash install.sh
pip3 install -r requirements.txt
echo
# Usage: python3 pacu.py
#Scout
echo "AWS Scout"
cd /opt 
git clone https://github.com/nccgroup/ScoutSuite.git
# Usage scout aws --profile basc -f
echo
echo "Wayback"
cd /opt
git clone git clone https://github.com/Rhynorater/waybacktool.git
echo
cd /opt
git clone https://github.com/GerbenJavado/LinkFinder.git
cd LinkFinder
pip3 install -r requirements.txt
python setup.py install
echo
echo "LockPhish"
cd /opt
git clone https://github.com/thelinuxchoice/lockphish.git
echo
echo "ShellPhish"
cd /opt
git clone https://github.com/thelinuxchoice/shellphish.git
echo
echo "AWS CLI"
pip install awscli
echo
echo "Malicious Macro Builder"
cd /opt/
git clone https://github.com/infosecn1nja/MaliciousMacroMSBuild.git
echo
echo "metagoofil"
apt -y install metagoofil
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
echo
cd /opt
git clone https://github.com/aboul3la/Sublist3r.git
cd Sublist3r
sudo pip install -r requirements.txt
sudo apt-get install python-requests
sudo apt-get install python-dnspython
echo
echo "dnstwister"
cd /opt
git clone https://github.com/elceef/dnstwist.git
sudo apt-get -y install python3-dnspython python3-geoip python3-whois \
python3-requests python3-ssdeep
echo
echo "RDPY"
cd /opt
git clone https://github.com/citronneur/rdpy.git
cd rdpy
python setup.py install
echo "EyeWitness"
cd /opt
git clone https://github.com/FortyNorthSecurity/EyeWitness.git
cd EyeWitness/setup
yes | ./setup.sh
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
echo "Userrecon"
cd /opt
git clone https://github.com/thelinuxchoice/userrecon.git
echo
echo "AD Recon - My Fav"
cd /opt
git clone https://github.com/sense-of-security/ADRecon.git
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
echo
echo "Fuzzdb you say?"
cd /opt
git clone https://github.com/fuzzdb-project/fuzzdb.git
echo
echo "Payloads All The Things"
cd /opt
git clone https://github.com/swisskyrepo/PayloadsAllTheThings.git
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
python setup.py install
echo
echo "GitRob"
cd /tmp
wget --no-check-certificate https://github.com/michenriksen/gitrob/releases/download/v2.0.0-beta/gitrob_linux_amd64_2.0.0-beta.zip
unzip gitrob_linux_amd64_2.0.0-beta.zip
mkdir -p /opt/gitrob
mv gitrob /opt/gitrob/
echo
echo "Google Play CLI"
apt -y install gplaycli
echo
echo
# MobSF Setup
sudo apt-get -y install openjdk-8-jdk
sudo apt install -y python3-venv python3-pip python3-dev build-essential libffi-dev libssl-dev libxml2-dev libxslt1-dev zlib1g-dev wkhtmltopdf
echo "MobSF"
cd /opt/
git clone https://github.com/MobSF/Mobile-Security-Framework-MobSF.git
cd Mobile-Security-Framework-MobSF/
pip3 install -r requirements.txt
yes |./setup.sh
echo
echo "Lee Baird Discover Script"
cd /opt
git clone https://github.com/leebaird/discover.git
cd discover
./update.sh
echo
echo "Don't Blink"
echo
# Save these two for later
# git clone https://github.com/jschicht/RawCopy.git
# git clone https://github.com/khr0x40sh/MacroShop.git
echo
#echo "My Cool Scripts"
#cd /opt
#git clone https://github.com/aryanguenthner/365.git
#cd ncis
#dos2unix *.sh *.py && chmod +x *.sh *.py
#echo
chmod -R 777 /home/kali/
echo
echo "Hacker Lives Matter"
source ~/.bashrc
date | tee kalisetupfinishdate.txt
updatedb
reboot
