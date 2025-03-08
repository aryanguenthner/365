#!/usr/bin/env bash

################################################
# Kali Linux Blue Team, Red Team, OSINT CTI Setup Automation Script
# Last Updated 03/08/2025, minor evil updates, pay me later
# Tested on Kali 2025.1 XFCE
# Usage: sudo git clone https://github.com/aryanguenthner/365 /opt/365
# chmod -R 777 /home/kali/ /opt/365
# sudo time ./kali-setup.sh
################################################
echo

# Exit on error
set -e

# TODO: Create a splash screen with menu options
# Menu options: 1 = Update Kali, 2 = Install kali Setup, 3 Install Kali Extra's, 4 Give me it all

# Add kali to sudoers# Check if 'kali' is already in the sudoers file
if sudo grep -q "^kali ALL=(ALL) NOPASSWD:ALL" /etc/sudoers.d/kali 2>/dev/null; then
    echo "'kali' is already in sudoers. Skipping addition."
else
    echo "Adding 'kali' to sudoers..."
    echo
    echo "kali ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/kali > /dev/null
    echo "'kali' added to sudoers."
fi

# Setting Variables
GREEN=032m
YELLOW=033m
BLUE=034m
PWD=$(pwd)
export LC_TIME="en_US.UTF-8"

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
date | tee kali-setup-date.txt
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
sudo sed -i '40s/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config > /dev/null 2>&1
sudo systemctl enable ssh > /dev/null && sudo service ssh restart > /dev/null
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
sudo apt-get update && apt-get -y full-upgrade
echo
sudo apt-get -y install mono-devel printer-driver-escpr pipx python3-distutils-extra torbrowser-launcher shellcheck yt-dlp libxcb-cursor0 libxcb-xtest0 docker.io docker-compose freefilesync libfuse2t64 libkrb5-dev metagoofil pandoc python3-docxtpl cmseek neo4j libu2f-udev freefilesync hcxdumptool hcxtools assetfinder colorized-logs xfce4-weather-plugin npm ncat shotwell obfs4proxy libc++1 sendmail ibus feroxbuster virtualenv mailutils mpack ndiff python3-pyinstaller python3-notify2 python3-dev python3-pip python3-bottle python3-cryptography python3-dbus python3-matplotlib python3-mysqldb python3-openssl python3-pil python3-psycopg2 python3-pymongo python3-sqlalchemy python3-tinydb python3-py2neo at bloodhound ipcalc nload crackmapexec hostapd dnsmasq gedit cupp nautilus dsniff build-essential cifs-utils cmake curl ffmpeg gimp git graphviz imagemagick libapache2-mod-php php-xml libmbim-utils nfs-common openssl tesseract-ocr vlc xsltproc xutils-dev driftnet websploit apt-transport-https openresolv screenfetch baobab speedtest-cli libffi-dev libssl-dev libxml2-dev libxslt1-dev zlib1g-dev awscli sublist3r w3m cups system-config-printer gobuster libreoffice gcc
echo

sudo apt-get autoremove -y && updatedb

# Setting Variables
GREEN=032m
YELLOW=033m
BLUE=034m

# Change directory to Kali Downloads
cd /home/kali/Downloads || exit 1
echo "Switched to /home/kali/Downloads"

# Function to check installation status
check_install() {
    if command -v "$1" &>/dev/null; then
        echo -e "\e[32m$1 is installed successfully!\e[0m"
    else
        echo -e "\e[31m$1 installation failed!\e[0m"
    fi
}

# === Google Chrome Install ===
GC="/usr/bin/google-chrome-stable"
if [ -f "$GC" ]; then
    echo -e "\e[32mGoogle Chrome is already installed!\e[0m"
else
    echo "Installing Google Chrome..."
    CHROME_DEB="google-chrome-stable_current_amd64.deb"
    wget -O "$CHROME_DEB" "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
    sudo dpkg -i "$CHROME_DEB" || sudo apt --fix-broken install -y
    rm "$CHROME_DEB"
    check_install "google-chrome-stable"
fi
echo

# === Signal Install ===
# echo "Installing Signal Desktop..."
# wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null
# echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt bookworm main' | sudo tee /etc/apt/sources.list.d/signal.list
# sudo apt update && sudo apt install -y signal-desktop
#check_install "signal-desktop"
# echo

# === Zoom Install ===
echo "Installing Zoom..."
ZOOM_DEB="zoom_amd64.deb"
wget -O "$ZOOM_DEB" "https://zoom.us/client/latest/zoom_amd64.deb"
sudo apt install -y ./"$ZOOM_DEB" || sudo apt --fix-broken install -y
rm "$ZOOM_DEB"
check_install "zoom"
echo

# === Discord Install ===
echo "Installing Discord..."
DISCORD_DEB="discord.deb"
wget -O "$DISCORD_DEB" "https://discord.com/api/download?platform=linux&format=deb"
sudo apt install -y ./"$DISCORD_DEB" || sudo apt --fix-broken install -y
rm "$DISCORD_DEB"
check_install "discord"
echo

# === Slack Install ===
echo "Installing Slack..."
SLACK_DEB="slack-desktop.deb"
wget -O "$SLACK_DEB" "https://downloads.slack-edge.com/releases/linux/4.33.90/prod/x64/slack-desktop-4.33.90-amd64.deb"
sudo dpkg -i "$SLACK_DEB" || sudo apt --fix-broken install -y
rm "$SLACK_DEB"
check_install "slack"
echo

# Variables
WKHTMLTOX_DEB_URL="https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-3/wkhtmltox_0.12.6.1-3.bookworm_amd64.deb"
WKHTMLTOX_DEB_FILE=wkhtmltox_0.12.6.1-3.bookworm_amd64.deb

# Download the wkhtmltox Debian package
echo "Downloading wkhtmltox..."
wget --no-check-certificate -O "$WKHTMLTOX_DEB_FILE" "$WKHTMLTOX_DEB_URL"
chmod -R 777 $WKHTMLTOX_DEB_FILE

# Install the wkhtmltox downloaded package
echo "Installing wkhtmltox..."
sudo dpkg -i "$WKHTMLTOX_DEB_FILE"

echo "Downloading and installing Shodan Nrich"
# Get your Shodan API Key
wget --no-check-certificate https://gitlab.com/api/v4/projects/33695681/packages/generic/nrich/latest/nrich_latest_x86_64.deb
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
pipx install git+https://github.com/Pennyw0rth/NetExec
pipx ensurepath --prepend
echo

# Updog Install
# Create a virtual environment
DOG=/root/.local/share/pipx/venvs/updog/bin/updog
if [ -f "$DOG" ]
then
    echo -e "\e[031mFound The Dog\e[0m"
else
    echo -e "\e[031mGetting the Dog\e[0m"
pipx install updog
pipx ensurepath
export PATH=/root/.local/bin:$PATH
echo 'export PATH=/root/.local/bin:$PATH' >> ~/.zshrc
source ~/.zshrc
    echo
fi
echo

# Keep Nmap scans Organized
sudo mkdir -p /home/kali/Desktop/testing/nmapscans/

# Upgrade Nmap User agent, Make Nmap Great Again
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

# Verify CloudFlare exists
# python3 -m http.server 443
# cloudflared tunnel -url localhost:443
CF=/usr/local/bin/cloudflared
if [ -f "$CF" ]
then
    echo -e "\e[031mFound The Cloud\e[0m"
else
    echo -e "\e[031mGetting the Cloud\e[0m"
    wget --no-check-certificate -O cloudflared.deb https://github.com/aryanguenthner/365/raw/refs/heads/master/cloudflared-linux-amd64.deb
    sudo dpkg -i cloudflared.deb > /dev/null 2>&1
    echo
    echo "The Cloud's in your computer"
fi
echo

# Verify Go 1.23.0 installation
if go version 2>/dev/null | grep -q "go1.23.0"; then
    echo "Go is version 1.23.0 installed"
else
    echo -e "\e[34mDownloading and Installing Go\e[0m"
    wget --no-check-certificate https://go.dev/dl/go1.23.0.linux-amd64.tar.gz
    sudo tar -xvzf go1.23.0.linux-amd64.tar.gz -C /usr/local
    echo
    echo "Go installation complete."
fi
echo

# Setting up Go environment variables
echo "Configuring Go environment..."
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.zshrc
echo 'export GOPATH=$HOME/go' >> ~/.zshrc
echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.zshrc
source /etc/profile
source ~/.zshrc  # Reload shell configuration
echo

# IP Address# 
echo "Check if hostname -I is already in /root/.zshrc"
if ! grep -q "hostname -I" /root/.zshrc; then
    echo "Adding 'hostname -I' to /root/.zshrc..."
    echo 'hostname -I' | sudo tee -a /root/.zshrc > /dev/null
else
    echo "'hostname -I' is already in /root/.zshrc. Skipping..."
fi
echo

cd /opt || exit 1
# Project Discovery Nuclei
go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
echo

# Project Discovery httpx
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
echo

# Install Katana - Web Crawler
go install -v github.com/projectdiscovery/katana/cmd/katana@latest
echo

# Install Project Discovery - Uncover
go install -v github.com/projectdiscovery/uncover/cmd/uncover@latest
echo

# Install gospider - Web Crawler
# https://github.com/jaeles-project/gospider
go install github.com/jaeles-project/gospider@latest
echo
# Install gobuster - Directory Buster
go install github.com/OJ/gobuster/v3@latest
echo

echo "Cewl Password Lists"
# cewl -m 8 https://www.bobandalice.com -c -e --with-numbers -w example-cewl.txt
git clone https://github.com/digininja/CeWL.git /opt/cewl
cd cewl
gem install mime-types
gem install mini_exiftool
gem install rubyzip
gem install spider
echo

# Verify gowitness 3.0.5 is in /opt/365
GOWIT=/opt/365/gowitness
if [ -f "$GOWIT" ]
then
    echo -e "\e[031mFound GoWitness 3.0.5\e[0m"
else
    echo -e "\e[031mDownloading Missing GoWitness 3.0.5\e[0m"
    chmod -R 777 /opt/365
    wget --no-check-certificate -O /opt/365/gowitness 'https://drive.google.com/uc?export=download&id=1C-FpaGQA288dM5y40X1tpiNiN8EyNJKS' # gowitness 3.0.5
fi
echo

# Ask user if they want to install extra Git repositories
cd /opt || exit 1
read -t 30 -p "Would you like to install extra Git repositories? (yes/no): " response
echo

# Default to "no" if no input is provided within 30 seconds
response=${response:-no}

if [[ "$response" == "yes" ]]; then
    echo "Proceeding with extra installations..."
    echo "This is going to take a minute hold my root-beer"
    echo

echo "PWN AD"
git clone https://github.com/Wh04m1001/DFSCoerce
echo

echo "Malicious Macro Builder"
git clone https://github.com/infosecn1nja/MaliciousMacroMSBuild.git
echo

echo "Subbrute"
git clone https://github.com/TheRook/subbrute.git
echo

echo "BridgeKeeper - Employee OSINT"
git clone https://github.com/aryanguenthner/BridgeKeeper.git
echo

echo "AD Recon - My Fav"
git clone https://github.com/sense-of-security/ADRecon.git
echo

echo "enum4linux-ng"
git clone https://github.com/cddmp/enum4linux-ng.git
echo

echo "Daniel Miessler Security List Collection"
git clone https://github.com/danielmiessler/SecLists.git
echo

echo "Awesome Incident Response"
git clone https://github.com/meirwah/awesome-incident-response.git
echo

echo "Fuzzdb"
git clone https://github.com/fuzzdb-project/fuzzdb.git
echo

echo "Payloads All The Things"
git clone https://github.com/swisskyrepo/PayloadsAllTheThings.git
echo

echo "Awesome XSS"
git clone https://github.com/s0md3v/AwesomeXSS.git
echo

echo "XSS Payloads"
git clone https://github.com/payloadbox/xss-payload-list.git
echo

echo "Foospidy Payloads"
git clone https://github.com/foospidy/payloads.git
echo

echo "Java Deserialization Exploitation (jexboss)"
git clone https://github.com/joaomatosf/jexboss.git
echo

echo "theHarvester"
git clone https://github.com/laramies/theHarvester.git
echo

echo "OWASP Cheat Sheet"
git clone https://github.com/OWASP/CheatSheetSeries.git
echo

echo "Pulse VPN Exploit"
git clone https://github.com/projectzeroindia/CVE-2019-11510.git
echo

echo "hruffleHog - Git Enumeration"
git clone https://github.com/dxa4481/truffleHog.git
echo

echo "Git Secrets"
git clone https://github.com/awslabs/git-secrets.git
echo

echo "Git Leaks"
git clone https://github.com/zricethezav/gitleaks.git

echo "Discover Admin Login Pages - Breacher"
git clone https://github.com/s0md3v/Breacher.git
echo

# Clone the PhoneInfoga repository
# You will need API to get most of this tool
echo "Cloning the PhoneInfoga repository..."
sudo git clone https://github.com/sundowndev/PhoneInfoga.git

# Change directory to the PhoneInfoga folder
echo "Changing directory to PhoneInfoga..."
cd PhoneInfoga || { echo "Failed to change directory to PhoneInfoga. Exiting."; exit 1; }

# Run the install script
echo "Running the PhoneInfoga install script..."
sudo curl -sSL https://raw.githubusercontent.com/sundowndev/PhoneInfoga/master/support/scripts/install | sudo bash

# Run PhoneInfoga
sudo mv ./phoneinfoga /usr/local/bin/phoneinfoga
echo "Running PhoneInfoga..."
sudo phoneinfoga scan -n 8085551212

# Windows Exploit Suggester Next Gen
echo
sudo git clone https://github.com/bitsadmin/wesng.git /opt/wseng
echo

echo "Password SprayingToolKit"
git clone https://github.com/byt3bl33d3r/SprayingToolkit.git /opt/SprayingToolkit
# Nmap works dont forget --> nmap -iL smb-ips.txt --stats-every=1m -Pn -p 445 -script smb-brute --script-args='smbpassword=Summer2023,userdb=usernames.txt,smbdomain=xxx.com,smblockout=true' -oA nmap-smb-brute-2023-07-19'
# Hydra works dont forget --> hydra -p Summer2019 -l Administrator smb://192.168.1.23
# Metasploit works dont forget --> 
# set smbpass Summer2019
# set smbuser Administrator
# set rhosts 192.168.1.251
# run
echo
echo "Extra Tools Installed"
else
    echo "Skipping extra Git repositories installation."
fi
echo

# Fix annoying apt-key
# If Needed
# sudo apt-key del <KEY_ID>
# <B9F8 D658 297A F3EF C18D  5CDF A2F6 83C5 2980 AECF>
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
#echo -e '\n'
#echo

# Insurance
# sudo apt-get --reinstall install python3-debian -y
# sudo apt --fix-broken install
# sudo apt autoremove -y
# systemctl restart ntp

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
# sendmail
echo

# Stop Docker
# Remove Docker Interface until you need it
sudo systemctl stop docker
sudo systemctl disable docker
sudo ip link delete docker0

echo "Checking if you need Virtualbox installed"
cd /home/kali/Downloads || exit 1
# Detect if running on VirtualBox or a physical machine
VBOX=$(sudo dmidecode -s system-manufacturer)  # e.g., "LENOVO" for physical machine
VBOX1=$(sudo dmidecode -s bios-version)  # "VirtualBox" if running inside a VM

# Check if running in VirtualBox
if [[ "$VBOX1" == "VirtualBox" ]]; then
    echo "Running inside VirtualBox. Skipping installation."
    exit 0
else
    echo "Running on a physical machine. Proceeding with installation."

# Add Oracle VirtualBox GPG key (alternative for apt-key deprecation)
echo "Adding Oracle VirtualBox GPG key..."
wget -qO- https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo tee /etc/apt/trusted.gpg.d/oracle_vbox_2016.asc > /dev/null

# Install prerequisites
echo "Installing VBox required packages..."
wget http://ftp.us.debian.org/debian/pool/main/libv/libvpx/libvpx7_1.12.0-1+deb12u3_amd64.deb
sudo dpkg -i ./libvpx7_1.12.0-1+deb12u3_amd64.deb

# Install VirtualBox and dependencies
echo "Installing VirtualBox..."
sudo apt-get install -y virtualbox virtualbox-dkms virtualbox-ext-pack virtualbox-guest-utils virtualbox-qt virtualbox-guest-x11 linux-headers-$(uname -r)

# Add current user to vboxusers group
echo "Adding user to vboxusers group..."
sudo usermod -a -G vboxusers $USER
echo "VirtualBox installation completed!"
fi
echo

# Insurance
# sudo modprobe vboxnetflt
# Cross your fingers
# Enable Kali Autologin

echo "Hack The Planet"
sed -i '120s/#autologin-user=/autologin-user=kali/g' /etc/lightdm/lightdm.conf
sed -i '121s/#autologin-user-timeout=0/autologin-user-timeout=0/g' /etc/lightdm/lightdm.conf

# Kali Setup Finish Time
date | tee kali-setup-finish-date.txt
echo
reboot
# Just in case DNS issues: nano -c /etc/resolvconf/resolv.conf.d/head
# Gucci Mang
# Pay me later
# https://sites.google.com/site/gdocs2direct/
