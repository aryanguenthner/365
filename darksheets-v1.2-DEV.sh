#!/usr/bin/env bash

#######################################################
# Made for doing CTI cyber security research on the Dark Deep Web
# Intended to be used on Kali Linux
# Updated for compatibility and better Tor handling
# Hacked on 02/01/2025, pay me later
# Great ideas
# install_addon "https://addons.mozilla.org/firefox/downloads/file/4141345/noscript-11.4.26.xpi" "noscript"
# install_addon "https://addons.mozilla.org/firefox/downloads/file/4125998/adblock_plus-3.17.1.xpi" "adblock_plus"
# install_addon "https://addons.mozilla.org/firefox/downloads/file/4151024/sponsorblock-5.4.15.xpi" "sponsorblock"

######################################################

# Banner
cat <<'EOF'
██████╗░░█████╗░██████╗░██╗░░██╗░██████╗██╗░░██╗███████╗███████╗████████╗░██████╗
██╔══██╗██╔══██╗██╔══██╗██║░██╔╝██╔════╝██║░░██║██╔════╝██╔════╝╚══██╔══╝██╔════╝
██║░░██║███████║██████╔╝█████═╝░╚█████╗░███████║█████╗░░█████╗░░░░░██║░░░╚█████╗░
██║░░██║██╔══██║██╔══██╗██╔═██╗░░╚═══██╗██╔══██║██╔══╝░░██╔══╝░░░░░██║░░░░╚═══██╗
██████╔╝██║░░██║██║░░██║██║░╚██╗██████╔╝██║░░██║███████╗███████╗░░░██║░░░██████╔╝
╚═════╝░╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░░╚═╝╚═════╝░╚═╝░░╚═╝╚══════╝╚══════╝░░░╚═╝░░░╚═════╝░
EOF
echo "CTI Cyber Threat intelligence v1.2"
echo
apt-get update
echo

# Todays Date
timedatectl set-timezone America/Los_Angeles
echo -e "\e[034mToday is\e[0m"
date '+%Y-%m-%d %r' | tee darksheets-install.date
echo

# Setting Variables
KALI=$(hostname -I)
CITY=$(curl -s http://ip-api.com/line?fields=timezone | cut -d "/" -f 2)
EXT=$(curl -s api.ipify.org)
PWD=$(pwd)
RED='\033[31m'

# Network Information
echo -e "\e[031mGetting Network Information\e[0m"
# Get public IP, Before Connecting to Dark Web
EXT=$(curl -s https://api64.ipify.org)
# Get country using ipinfo.io
COUNTRY=$(curl -s ipinfo.io/country)
# Get Kali IP (local IP)
KALI=$(hostname -I | awk '{print $1}')

# Print in table format
echo "---------------------------------"
printf "| %-12s | %-15s |\n" "Label" "Value"
echo "---------------------------------"
printf "| %-12s | %-15s |\n" "Public IP" "$EXT"
printf "| %-12s | %-15s |\n" "Country" "$COUNTRY"
printf "| %-12s | %-15s |\n" "Kali IP" "$KALI"
echo "---------------------------------"

# Dependencies Check
# Must have TheDevilsEye,LibreOffice,TorGhost,Tor,FireFox Set to allow Onion Sites

# Editing Firefox about:config this allows DarkWeb .onion links to be opened with Firefox
echo 'user_pref("network.dns.blockDotOnion", false);' > user.js
mv user.js /home/kali/.mozilla/firefox/*default-esr/
echo

# Verify the Devil exists
#E=/usr/local/bin/eye
E=/root/.local/share/pipx/venvs/thedevilseye/bin/eye
if [ -f "$E" ]
then
    echo -e "\e[031mFound for the Devil's Eye\e[0m"
else
    echo -e "\e[031mGetting the Devil\e[0m"
    sudo pipx install thedevilseye==2022.1.4.0 > /dev/null 2>&1
    echo

echo "The Devil's in your computer"
fi
echo

# Verify LibreOffice is installed
L=/usr/bin/libreoffice
if [ -f "$L" ]
then
    echo -e "\e[031mFound LibreOffice\e[0m"
else
    echo -e "\e[031mPlease wait while LibreOffice is installed\e[0m"
    apt-get install libreoffice
fi
echo

# Install TorGhost
# Example Country Codes: ca,mx,us,ru,br,bo,de,gb,fr,ir,by,cn
TORNG=/usr/bin/torghostng
if [ -f "$TORNG" ]
then
    echo -e "\e[031mFound TorghostNG\e[0m"
    echo
else
    echo
# Install TorghostNG
   cd /opt
   sudo git clone https://github.com/aryanguenthner/TorghostNG
   cd TorghostNG
   sudo touch /etc/sysctl.conf
   sudo python3 install.py
   echo "TorghostNG is installed"
fi
echo

# What are you researching?
# Create Results File
RESULT_FILE="results+onions.txt"
echo -en "\e[031mWhat are you researching: \e[0m"
read -e SEARCH
echo

# Simulate Progress Bar
echo "Searching for Onions..."
echo -ne '#####                     (33%)\r'
sleep 1
echo -ne '#############             (66%)\r'
sleep 1
echo -ne '#######################   (100%)\r'
echo -ne '\n'
echo

# Perform Devils Eye Search
echo "Saving results to $RESULT_FILE"
sudo /root/.local/share/pipx/venvs/thedevilseye/bin/eye -q "$SEARCH" | grep ".onion" > "$RESULT_FILE"
sed '/^invest/d' "$RESULT_FILE" > "$RESULT_FILE.tmp" && mv "$RESULT_FILE.tmp" "$RESULT_FILE"
sort -u "$RESULT_FILE" -o "$RESULT_FILE"
echo
echo -e "\e[031mTotal Onions Found:\e[0m"
wc "$RESULT_FILE" | awk '{print $1}'
echo

# Display Results
echo -e "\e[031mTop Results\e[0m"
head "$RESULT_FILE"
echo
echo -e "\e[031mTotal Onions Found:\e[0m"
echo "Saved results to $RESULT_FILE."
echo

# Darksheets Results
echo -e "\e[031mOpen a darksheet with results y/n: \e[0m"
read -e OPEN1
    echo
# Open spreadsheet with results
if [ "$OPEN1" == y ]
then
    echo -e "\e[031mdarksheet results\e[0m"
    echo "Exit DarkSheets: CTRL + c"
    echo
    echo "Pro Tip: Use NoScript! Block Javascript!"
    echo
    echo "To continue press:    CTRL + c"
sudo qterminal -e libreoffice --calc "$PWD"/results+onions.txt > /dev/null 2>&1
    echo
else
    echo "Maybe next time"
fi
    echo

# Ensure Tor is Installed and Running
if ! command -v tor >/dev/null; then
    echo "Tor is not installed. Installing..."
    sudo apt install -y tor torbrowser-launcher python3-stem
    echo
fi
    echo
if ! systemctl is-active --quiet tor; then
    echo "Starting Tor service..."
    sudo systemctl start tor
    echo
fi
echo

# Ask the user if they want to connect to the dark web
echo -e "Do you want to connect to the dark web?: "
read -e CONNECT
if [ "$CONNECT" == "y" ]
then
    echo "Connecting to the Dark Web"
    echo
    torghostng -id ca
    echo
    echo "Attempting To Connect to the Dark Web"
# Simulate Progress Bar
    echo -ne '#####                     (33%)\r'
    sleep 1
    echo -ne '#############             (66%)\r'
    sleep 1
    echo -ne '#######################   (100%)\r'
    echo -ne '\n'
    echo
# Get Dark Web IP
EXT=$(curl --socks5-hostname 127.0.0.1:9050 -s https://check.torproject.org/api/ip)
# Get country using ipinfo.io
COUNTRY=$(curl --socks5-hostname 127.0.0.1:9050 -s ipinfo.io/country)
# Get Kali IP (local IP)
KALI=$(hostname -I | awk '{print $1}')

# Print in table format
echo "---------------------------------"
printf "| %-12s | %-15s |\n" "Label" "Value"
echo "---------------------------------"
printf "| %-12s | %-15s |\n" "Dark Web IP" "$EXT"
printf "| %-12s | %-15s |\n" "Country" "$COUNTRY"
printf "| %-12s | %-15s |\n" "Kali IP" "$KALI"
echo "---------------------------------"
echo
# Open Firefox
echo -e "\e[031mOpen Firefox to view results y/n: \e[0m"
read -e OPEN2
echo
HIT1=$(awk 'FNR == 1 {print $1}' results+onions.txt)
if [ "$OPEN2" == y ]
then
    echo "Opening Firefox with the First Result from DarkSheets"
    echo
sudo qterminal -e su -c "firefox $HIT1" kali > /dev/null 2>&1
    echo
    echo "To continue: CTRL + c"
    echo
else
    echo "Maybe next time"
fi
    echo
    echo "DarkSheets script execution completed."
    echo
else
    echo "Exiting Tor In Progress"
    echo
    sudo torghostng -x
    echo "Tor exited successfully."
fi
echo

echo "Exit Tor type: torghostng -x"
#Pay Me later
