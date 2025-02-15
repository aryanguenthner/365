#!/usr/bin/env bash

################################################
# Kali Linux Red Team Setup Automation Script
# Last Updated 02/15/2025, minor evil updates, pay me later
# Tested on Kali 2024.4 XFCE
# Usage: sudo git clone https://github.com/aryanguenthner/365 /opt/
# cd 365 && sudo chmod a+x *.sh
# chmod -R 777 /home/kali/ /opt/365
# sudo time ./kali-setup.sh 2>&1 | tee kali.log
################################################
echo
# Add kali to sudoers
echo "kali ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/kali > /dev/null 2>&1
echo

# Setting Variables
YELLOW=033m
BLUE=034m
PWD=$(pwd)

# Get the directory where the kali-setup.sh is executed
script_dir=$(pwd)

# Define output log file in the same directory
log_file="${script_dir}/kali.log"

# Redirect all stdout and stderr to the log file
exec > >(tee -a "$log_file") 2>&1

# Start your script here
echo "Running the kali-setup.sh script..."
sleep 2
echo "Script Running!"
echo

# Today's Date
timedatectl set-timezone America/Los_Angeles
timedatectl set-ntp true
echo -e "\e[034mToday is\e[0m"
date '+%Y-%m-%d %r' | tee kali-setup-date.txt
echo

echo "Getting BIOS Info"
sudo dmidecode -s bios-version | tee /home/kali/Desktop/bios-information.txt
echo
# Network Information
# Get location details using ipinfo.io
# Fetch Public IP using multiple sources (fallback if one fails)
EXT=$(curl -s https://api64.ipify.org || curl -s https://ifconfig.me || curl -s https://checkip.amazonaws.com)

# If IP is still empty, set a default message
if [[ -z "$EXT" ]]; then
    EXT="Unavailable"
fi

sudo apt-get update && apt-get -y install jq > /dev/null 2>&1
echo
echo -e "\e[031mGetting Network Information\e[0m"
# Get location details using ipinfo.io
LOCATION=$(curl -s ipinfo.io/json)
COUNTRY=$(echo "$LOCATION" | jq -r '.country')
REGION=$(echo "$LOCATION" | jq -r '.region')
CITY=$(echo "$LOCATION" | jq -r '.city')

# Get local Kali IP
KALI=$(hostname -I | awk '{print $1}')
SUBNET=`ip r | awk 'NR==2' | awk '{print $1}'`

# Print in table format
echo "---------------------------------"
printf "| %-12s | %-20s |\n" "Label" "Value"
echo "---------------------------------"
printf "| %-12s | %-20s |\n" "Public IP" "$EXT"
printf "| %-12s | %-20s |\n" "Country" "$COUNTRY"
printf "| %-12s | %-20s |\n" "State" "$REGION"
printf "| %-12s | %-20s |\n" "City" "$CITY"
printf "| %-12s | %-20s |\n" "Kali IP" "$KALI"
printf "| %-12s | %-20s |\n" "Subnet" "$SUBNET"
echo "---------------------------------"
echo
sleep 2

# Disable IPv6
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1"  >> /etc/sysctl.conf
echo "net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf

# Hackers like SSH
echo "Enabling SSH"
echo
sed -i '40s/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config > /dev/null 2>&1
sudo systemctl enable ssh && sudo service ssh restart
echo

# Kali Updates
echo "It's a good idea to update and upgrade Kali first before running kali-setup.sh"
echo
echo "Be Patient, Installing Kali Dependencies"
echo

# TODO: Update Fix the xfce4 panel backup & restore
# sudo xfce4-panel-profiles load /opt/365/kali-panel-backup.tar.bz2 > /dev/null 2>&1
# sudo xfce4-panel > /dev/null 2>&1

# Prepare Kali installs
apt-get update && apt-get -y upgrade && full-upgrade && apt -y autoremove && updatedb
echo
sudo apt-get install -y mono-devel printer-driver-escpr pipx python3-distutils-extra torbrowser-launcher shellcheck wkhtmltopdf yt-dlp libxcb-cursor0 libxcb-xtest0 docker.io docker-compose freefilesync libfuse2t64 libkrb5-dev metagoofil pandoc python3-docxtpl cmseek neo4j libu2f-udev freefilesync hcxdumptool hcxtools assetfinder colorized-logs xfce4-weather-plugin npm ncat shotwell obfs4proxy libc++1 sendmail ibus feroxbuster virtualenv mailutils mpack ndiff python3-pyinstaller python3-notify2 python3-dev python3-pip python3-bottle python3-cryptography python3-dbus python3-matplotlib python3-mysqldb python3-openssl python3-pil python3-psycopg2 python3-pymongo python3-sqlalchemy python3-tinydb python3-py2neo at bloodhound ipcalc nload crackmapexec hostapd dnsmasq gedit cupp nautilus dsniff build-essential cifs-utils cmake curl ffmpeg gimp git graphviz imagemagick libapache2-mod-php php-xml libmbim-utils nfs-common openssl tesseract-ocr vlc xsltproc xutils-dev driftnet websploit apt-transport-https openresolv screenfetch baobab speedtest-cli libffi-dev libssl-dev libxml2-dev libxslt1-dev zlib1g-dev awscli sublist3r w3m cups system-config-printer gobuster libreoffice
echo

# Some dependencies
sudo apt install -y gcc make linux-headers-$(uname -r)

# Variables
CHROME_DEB_URL="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
DEB_FILE="google-chrome-stable_current_amd64.deb"

# Download the latest Google Chrome Debian package
echo "Downloading and Installing Google Chrome..."
wget -O "$DEB_FILE" "$CHROME_DEB_URL"

# Install the downloaded package
echo "Installing Google Chrome..."
sudo dpkg -i "$DEB_FILE"

# Fix any dependency issues
echo "Fixing dependencies..."
sudo apt-get install -f -y

# Clean up
echo "Cleaning up..."
rm "$DEB_FILE"

echo "Google Chrome installation complete!"
echo

# Signal Install
# Step 1: Install the official public software signing key
echo "Installing the Signal Desktop public software signing key..."
wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg
sudo mv signal-desktop-keyring.gpg /usr/share/keyrings/

# Step 2: Add the Signal repository to the list of repositories
echo "Adding Signal Desktop repository..."
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' | sudo tee /etc/apt/sources.list.d/signal-xenial.list

# Step 3: Update the package database and install Signal
echo "Updating package database and installing Signal Desktop..."
sudo apt update && sudo apt install -y signal-desktop
echo
echo "Signal Desktop installation complete."
echo

# Download and Install Zoom
# Define Zoom download URL and filename
ZOOM_URL="https://zoom.us/client/latest/zoom_amd64.deb"
ZOOM_DEB="zoom_amd64.deb"

# Download Zoom .deb package
echo "Downloading Zoom for Linux..."
wget -O $ZOOM_DEB $ZOOM_URL

# Install Zoom
echo "Installing Zoom..."
sudo apt install -y ./$ZOOM_DEB

# Remove the downloaded .deb file
echo "Cleaning up..."
rm $ZOOM_DEB
echo "Zoom installation complete."
echo

# Download and Install Discord
# Define Discord download URL and filename
DISCORD_URL="https://discord.com/api/download?platform=linux&format=deb"
DISCORD_DEB="discord.deb"

# Download Discord .deb package
echo "Downloading Discord for Linux..."
wget -O $DISCORD_DEB $DISCORD_URL

# Install Discord
echo "Installing Discord..."
sudo apt install -y ./$DISCORD_DEB
echo

# Remove the downloaded .deb file
echo "Cleaning up..."
rm $DISCORD_DEB
echo "Discord installation complete."
echo

# Define the Slack download URL
SLACK_URL="https://downloads.slack-edge.com/releases/linux/4.33.90/prod/x64/slack-desktop-4.33.90-amd64.deb"
echo

# Download the latest Slack .deb package
echo "Downloading the latest Slack .deb package..."
wget -O slack-desktop.deb $SLACK_URL

# Install the Slack .deb package
echo "Installing Slack..."
sudo dpkg -i slack-desktop.deb
echo

echo "Hey Slacker- Slack installation complete!"
echo

# Variables
WKHTMLTOX_DEB_URL="https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-3/wkhtmltox_0.12.6.1-3.bookworm_amd64.deb"
WKHTMLTOX_DEB_FILE=wkhtmltox_0.12.6.1-3.bookworm_amd64.deb

# Download the wkhtmltox Debian package
echo "Downloading wkhtmltox..."
wget -O "$WKHTMLTOX_DEB_FILE" "$WKHTMLTOX_DEB_URL"
chmod -R 777 $WKHTMLTOX_DEB_FILE

# Install the wkhtmltox downloaded package
echo "Installing wkhtmltox..."
sudo dpkg -i "$WKHTMLTOX_DEB_FILE"

echo "Downloading and installing Shodan Nrich"
# Get your Shodan API Key
wget https://gitlab.com/api/v4/projects/33695681/packages/generic/nrich/latest/nrich_latest_x86_64.deb
sudo dpkg -i nrich_latest_x86_64.deb
echo

# Create the docker plugins directory
mkdir -p ~/.docker/cli-plugins
# Download the CLI into the plugins directory
curl -sSL https://github.com/docker/compose/releases/download/v2.0.1/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
# Make the CLI executable
chmod +x ~/.docker/cli-plugins/docker-compose

echo "Installing NetExec"
# TODO: Add NetExec Examples, add automation script
# Enhanced CME
sudo pipx install git+https://github.com/Pennyw0rth/NetExec
sudo pipx ensurepath --prepend
echo

# Get Pippy wit it
#python3 -m pip install --upgrade pip
#pip3 install --upgrade setuptools

#echo "Installing psycopg"
#pip install psycopg
#echo
## Install virtualenv
#sudo apt install python3-venv

# Updog
# Create a virtual environment
python3 -m venv myenv
# Activate the virtual environment
source myenv/bin/activate
# Now install updog
pip install updog
echo

# Keep Nmap scans Organized
sudo mkdir -p /home/kali/Desktop/testing/nmapscans/

# Upgrade Nmap User agent
echo "Current Nmap User Agent"
sed -n '160p' /usr/share/nmap/nselib/http.lua
echo
echo "Upgrading Nmap User Agent"
echo "Before"
sed -n '160p' /usr/share/nmap/nselib/http.lua
# Works sed -i '160c\local USER_AGENT = stdnse.get_script_args('\'http.useragent\'') or "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/601.3.9 (KHTML, like Gecko)"' /usr/share/nmap/nselib/http.lua
sed -i '160c\local USER_AGENT = stdnse.get_script_args('\'http.useragent\'') or "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36"' /usr/share/nmap/nselib/http.lua
echo
echo "After"
sed -n '160p' /usr/share/nmap/nselib/http.lua
echo

# Nmap bootstrap file checker, creates beautiful nmap reports
NB=/opt/365/nmap-bootstrap.xsl
if [ -f $NB ]
then

    echo "Found nmap-bootstrap.xsl"

else

    echo -e "\e[034mFetching Missing $BOOTSTRAP File\e[0m"
wget --no-check-certificate -O /home/kali/Desktop/testing/nmapscans/nmap-bootstrap.xsl https://raw.githubusercontent.com/aryanguenthner/nmap-bootstrap-xsl/stable/nmap-bootstrap.xsl > /dev/null 2>&1

fi
echo

# Did you say Cloudflare Tunnel?
# qterminal -e python3 -m http.server 80
# qterminal -e cloudflared tunnel -url localhost:80
sudo dpkg -i /opt/365/cloudflared-linux-amd64.deb

# Go Env Paths
echo 'export PATH="$PATH:/usr/local/go/bin"' >> /root/.zshrc
echo 'export PATH="$PATH:$HOME/go/bin"' >> /root/.zshrc
echo 'export PATH="$PATH:/root/go"' >> /root/.zshrc

# Updating /opt/365 permissions and file execution
chmod -R 777 /opt/365
chmod a+x /opt/365/*.sh /opt/365/*.py

# Just Go for it!
wget --no-check-certificate https://go.dev/dl/go1.23.0.linux-amd64.tar.gz
tar -xvzf go1.23.0.linux-amd64.tar.gz
sudo mv go /usr/local
echo
# Get go Version
sudo source ~/.zshrc
go version

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

# Install gospider - Web Crawler
# https://github.com/jaeles-project/gospider
cd /opt
go install github.com/jaeles-project/gospider@latest

# Install gobuster - Directory Buster
cd /opt
go install github.com/OJ/gobuster/v3@latest
echo

echo "Cewl Password Lists"
# cewl -m 8 https://www.example.com -c -e --with-numbers -w example-cewl.txt
cd /opt
git clone https://github.com/digininja/CeWL.git
gem install mime-types
gem install mini_exiftool
gem install rubyzip
gem install spider
echo

# Ask user if they want to install extra Git repositories
read -t 30 -p "Would you like to install extra Git repositories? (yes/no): " response
echo

# Default to "no" if no input is provided within 30 seconds
response=${response:-no}

if [[ "$response" == "yes" ]]; then
    echo "Proceeding with extra installations..."
    echo "This is going to take a minute hold my root-beer"
    echo

echo "PWN AD"
cd /opt
git clone https://github.com/Wh04m1001/DFSCoerce
echo

echo "Malicious Macro Builder"
cd /opt
git clone https://github.com/infosecn1nja/MaliciousMacroMSBuild.git
echo

echo "Subbrute"
cd /opt
git clone https://github.com/TheRook/subbrute.git
echo

echo "BridgeKeeper - Employee OSINT"
cd /opt
git clone https://github.com/aryanguenthner/BridgeKeeper.git
echo

echo "AD Recon - My Fav"
cd /opt
git clone https://github.com/sense-of-security/ADRecon.git
echo

echo "enum4linux-ng"
cd /opt
git clone https://github.com/cddmp/enum4linux-ng.git
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

echo "SprayingToolKit"
cd /opt
git clone https://github.com/byt3bl33d3r/SprayingToolkit.git
: ' Nmap works dont forget --> nmap -iL smb-ips.txt --stats-every=1m -Pn -p 445 -script smb-brute --script-args='smbpassword=Summer2023,userdb=usernames.txt,smbdomain=xxx.com,smblockout=true' -oA nmap-smb-brute-2023-07-19
'
echo
: ' Hydra works dont forget --> hydra -p Summer2019 -l Administrator smb://192.168.1.23
Metasploit works dont forget --> 
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

echo "Discover Admin Login Pages - Breacher"
cd /opt
git clone https://github.com/s0md3v/Breacher.git
echo

# Clone the PhoneInfoga repository
echo "Cloning the PhoneInfoga repository..."
sudo git clone https://github.com/sundowndev/PhoneInfoga.git

# Change directory to the PhoneInfoga folder
echo "Changing directory to PhoneInfoga..."
cd PhoneInfoga || { echo "Failed to change directory to PhoneInfoga. Exiting."; exit 1; }

# Run the install script
echo "Running the PhoneInfoga install script..."
sudo curl -sSL https://raw.githubusercontent.com/sundowndev/PhoneInfoga/master/support/scripts/install | sudo bash

# Run PhoneInfoga
echo "Running PhoneInfoga..."
sudo ./phoneinfoga
# Windows Exploit Suggester Next Gen
echo
cd /opt
sudo git clone https://github.com/bitsadmin/wesng.git
echo

echo "Extra installations complete."

else
    echo "Skipping extra Git repositories installation."
fi
echo

# Fix annoying apt-key
# If Needed
# sudo apt-key del <KEY_ID>
#      <B9F8 D658 297A F3EF C18D  5CDF A2F6 83C5 2980 AECF>
# sudo apt-key export 058F8B6B | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/mongo.gpg
# sudo apt-key export 2007B954 | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/msf.gpg
# sudo apt-key export 038651BD | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/slack.gpg

## Ivre Dependencies
#sudo pip install tinydb
#sudo pip install py2neo
#echo

# Install Ivre.Rocks
#echo
#sudo apt-get -y install ivre
#echo

#Ivre Database init, data download & importation
#echo
#echo -e '\r'
#yes | ivre ipinfo --init
#yes | ivre scancli --init
#yes | ivre view --init
#yes | ivre flowcli --init
#yes | sudo ivre runscansagentdb --init
# 40 Min download --> sudo ivre ipdata --download
#echo -e '\r'
#echo

# Can I get a Witness?
# Get Screenshots
# ./gowitness file -f url-results.txt
# "View Report http://localhost:7171"
# ./gowitness server report
# Can I get a gowitness?
sudo mkdir -p /home/kali/Desktop/testing/urlwitness/gowitness
GWIT=/home/kali/Desktop/testing/urlwitness/gowitness
if [ -f "$GWIT" ]
then
    echo "Found gowitness"

else
    echo -e "\e[034mDownloading Missing $GWIT\e[0m"
    wget --no-check-certificate -O /home/kali/Desktop/testing/urlwitness/gowitness 'https://drive.google.com/uc?export=download&id=1hXJAEQAFqFu5A4uR14dUWWdwWceLHz6D'
    chmod -R 777 /home/kali

fi
echo

# Insurance
# sudo apt-get --reinstall install python3-debian -y
# sudo apt --fix-broken install
# sudo apt autoremove -y
# systemctl restart ntp
echo

# If installing in VM
#VBOX1=$(dmidecode -s bios-version)
#if [ VBOX1=Virtualbox ] 
# then
# echo "Skipping VBox Install"
# else
# apt-get install virtualbox
#fi

## VirtualBox Hack for USB Devices
#sudo usermod -a -G vboxusers $USER

# TODO: Add this to VLC https://broadcastify.cdnstream1.com/24051
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

# TODO
# # https://github.com/balena-io/etcher
#echo "Downloading Etcher USB Media Creator"
#mkdir -p /opt/balena-etcher-electron/chrome-sandbox
#curl -lsLf \
#   'https://dl.cloudsmith.io/public/balena/etcher/setup.deb.sh' \
#   | sudo -E bash
# Install Etcher
#sudo apt-get update && apt-get -y install balena-etcher-electron
#echo

# TODO: Check this out
# text in your terminal > ansi2html > nmap-report.html
# ssmtp <--works good, just doesnt play with sendmail.
# did not install > openjdk-13-jdk libc++1-13 libc++abi1-13 libindicator3-7 libunwind-13 python3.8-venv libappindicator3-1 
echo

# Stop Docker
# Remove Docker Interface until you need it
sudo systemctl stop docker && systemctl disable docker && ip link delete docker0
echo

# IP Address
# Updated
sudo echo 'hostname -I' >> /root/.zshrc

:'
# Customize Kali Paths
# Set HISTCONTROL
echo "export HISTCONTROL=ignoredups" >> /root/.zshrc

# Update PATH variable with various directories
echo "export PATH=$PATH:/root/work" >> /root/.zshrc
echo "export PATH=$PATH:/usr/local/bin:/usr/local/sbin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/games:/usr/games" >> /root/.zshrc
echo "export PATH=$PATH:/usr/lib/jvm/java-11-openjdk-amd64/:/snap/bin" >> /root/.zshrc
echo "export PATH=$PATH:/root/.local/bin" >> /root/.zshrc

# Abide by the Source
source ~/.zshrc
echo
'

# Kali Setup Finish Time
date | tee kali-setup-finish-date.txt

updatedb
echo "Hack The Planet"
echo "Enable Kali Autologin"
sed -i '120s/#autologin-user=/autologin-user=kali/g' /etc/lightdm/lightdm.conf
sed -i '121s/#autologin-user-timeout=0/autologin-user-timeout=0/g' /etc/lightdm/lightdm.conf
sudo service lightdm restart

echo
reboot
# Just in case DNS issues: nano -c /etc/resolvconf/resolv.conf.d/head
# Gucci Mang
# Pay me later
