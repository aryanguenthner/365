#!/usr/bin/env bash
#######################################################
# Made for OSINT CTI cyber security research on the Dark Deep Web
# Intended to be used on Kali Linux
# Updated for compatibility and better Tor handling
# Hacked on 02/09/2025, pay me later
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
echo "OSINT CTI Cyber Threat intelligence v1.2"
# Darksheets is meant for researchers and educational purposes only. This was developed to speed the investigation, enable clear documentation without pain and suffering. Pay me later.

# Consider using spiderfoot,redtiger
# https://github.com/smicallef/spiderfoot
# https://github.com/loxy0dev/RedTiger-Tools
echo
# Todays Date
sudo timedatectl set-timezone America/Los_Angeles
echo -e "\e[034mToday is\e[0m"
date '+%Y-%m-%d %r' | tee darksheets.run.date
# Setting Variables
CITY=$(curl -s http://ip-api.com/line?fields=timezone | cut -d "/" -f 2)
PWD=$(pwd)
RED='\033[31m'
RANDOM=$$
echo

# Network Information
echo -e "\e[031mGetting Network Information\e[0m"
# Get public IP, Before Connecting to Dark Web
# Get location details using ipinfo.io
# Fetch Public IP using multiple sources (fallback if one fails)
EXT=$(curl -s https://api64.ipify.org || curl -s https://ifconfig.me || curl -s https://checkip.amazonaws.com)

# If IP is still empty, set a default message
if [[ -z "$EXT" ]]; then
    EXT="Unavailable"
fi

# Get location details using ipinfo.io
LOCATION=$(curl -s ipinfo.io/json)
COUNTRY=$(echo "$LOCATION" | jq -r '.country')
REGION=$(echo "$LOCATION" | jq -r '.region')
CITY=$(echo "$LOCATION" | jq -r '.city')

# Get local Kali IP
KALI=$(hostname -I | awk '{print $1}')

# Print in table format
echo "---------------------------------"
printf "| %-12s | %-20s |\n" "Label" "Value"
echo "---------------------------------"
printf "| %-12s | %-20s |\n" "Public IP" "$EXT"
printf "| %-12s | %-20s |\n" "Country" "$COUNTRY"
printf "| %-12s | %-20s |\n" "State" "$REGION"
printf "| %-12s | %-20s |\n" "City" "$CITY"
printf "| %-12s | %-20s |\n" "Kali IP" "$KALI"
echo "---------------------------------"
echo

# Dependencies Check
# Must have LibreOffice,TheDevilsEye,Tor,TorGhost,OnionVerifier,FireFox
echo "Checking Requirements"
sudo apt-get install -y tor torbrowser-launcher python3-stem  > /dev/null 2>&1
# Simulated Progress Bar
echo -ne '#####                     (33%)\r'
sleep 1
echo -ne '#############             (66%)\r'
sleep 1
echo -ne '#######################   (100%)\r'
echo -ne '\n'
echo
echo "Config Looks Good So Far"
echo
# Python3 Verify Onion Links
#OINFO=/opt/365/onion_verifier.py
#if [ -f "$OINFO" ]
#then
#    echo -e "\e[031mFound Onion Verifier\e[0m"
#else
#    echo -e "\e[031mGetting Onion Verifier\e[0m"
#    sudo cp /opt/365/onion_verifier.py "$PWD"
#fi
#echo

# Verify LibreOffice is installed
L=/usr/bin/libreoffice
if [ -f "$L" ]
then
    echo -e "\e[031mFound LibreOffice\e[0m"
else
    echo -e "\e[031mPlease wait while LibreOffice is installed\e[0m"
    sudo apt-get install -y libreoffice
fi

# Editing Firefox about:config this allows DarkWeb .onion links to be opened with Firefox
#echo 'user_pref("network.dns.blockDotOnion", false);' > user.js
#sudo mv user.js /home/kali/.mozilla/firefox/*default-esr/
USER_JS_PATH=$(find /home/kali/.mozilla/firefox/ -name "user.js" | head -n 1)

if [[ -f "$USER_JS_PATH" ]]; then
    if ! grep -q 'user_pref("network.dns.blockDotOnion", false);' "$USER_JS_PATH"; then
        echo 'user_pref("network.dns.blockDotOnion", false);' >> "$USER_JS_PATH"
    fi
else
    echo 'user_pref("network.dns.blockDotOnion", false);' > user.js
    sudo mv user.js /home/kali/.mozilla/firefox/*default-esr/
fi
echo

TORNG=/usr/bin/torghostng
if [ -f "$TORNG" ]
then
    echo -e "\e[031mFound TorghostNG\e[0m"
    echo
else
    echo
    sudo git clone https://github.com/aryanguenthner/torghostng /opt/torghostng
    cd /opt/torghostng
    sudo touch /etc/sysctl.conf
    sudo python3 install.py
    echo "TorghostNG is installed"
fi

# Verify the Devil exists
#E=/usr/local/bin/eye
E=/root/.local/share/pipx/venvs/thedevilseye/bin/eye
if [ -f "$E" ]
then
    echo -e "\e[031mFound The Devil\e[0m"
else
    echo -e "\e[031mGetting the Devil\e[0m"
    sudo pipx install thedevilseye==2022.1.4.0 > /dev/null 2>&1
    echo
    echo "The Devil's in your computer"
fi
echo

# What are you researching?
#echo -en "\e[031mWhat are you researching: \e[0m"
#read -e SEARCH
read -p "What are you researching: " SEARCH
echo
echo -e "\nSearching for $SEARCH"
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

# Create Results File
# Perform Devils Eye Search
RESULTS_FILE="$(date +%Y%m%d).results.onion_$RANDOM.csv"
sudo /root/.local/share/pipx/venvs/thedevilseye/bin/eye -q "$SEARCH" | grep ".onion" > "$RESULTS_FILE"
sed '/^invest/d; /^222/d; /\.onion$/!d' "$RESULTS_FILE" > "$RESULTS_FILE.tmp" && mv "$RESULTS_FILE.tmp" "$RESULTS_FILE"
sort -u "$RESULTS_FILE" -o "$RESULTS_FILE"
echo -e "\e[31mOnions Found:\e[0m $(wc -l < "$RESULTS_FILE")"
echo

# Display 10 Results
head "$RESULTS_FILE"
echo
echo "Saved results to "$PWD"/"$RESULTS_FILE""
echo

# Ask the user if they want to connect to the dark web
read -p "Do you want to connect to the dark web? (y/n): " CONNECT

# Check for TOR Connection
echo "Starting Tor service"
sudo systemctl start tor
echo

if [[ "$CONNECT" == "y" || "$CONNECT" == "Y" ]]; then
echo "⚡ Attempting to connect to the Dark Web..."
echo
# Starting Tor in the Netherlands
# Example Country Codes: nl,de,us,ca,mx,ru,br,bo,gb,fr,ir,by,cn
sudo torghostng -id nl
echo
echo -e "\e[031m⏳ Establishing dark web connection:\e[0m"
    
# Simulated Progress Bar
echo -ne '#####                     (33%)\r'
sleep 1
echo -ne '#############             (66%)\r'
sleep 1
echo -ne '#######################   (100%)\r'
echo -ne '\n'
echo
echo "✅ Connection Established. You can now access .onion sites."
else
echo "🚫 Aborting Dark Web connection."
fi

# Get Dark Web IP
# Get location details using ipinfo.io
# Fetch Public IP using multiple sources (fallback if one fails)
# Check if connected to Tor & extract IP correctly
TOR_IP_JSON=$(curl --socks5-hostname 127.0.0.1:9050 -s --max-time 4 https://check.torproject.org/api/ip)
TOR_IP=$(echo "$TOR_IP_JSON" | jq -r '.IP // empty')

# Fetch Public IP and Location
if [[ -n "$TOR_IP" ]]; then
    EXT="$TOR_IP"
    LOCATION=$(curl --socks5-hostname 127.0.0.1:9050 -s "http://ip-api.com/json/$EXT")
else
    EXT=$(curl -s https://api64.ipify.org || curl -s https://ifconfig.me || curl -s https://checkip.amazonaws.com)
    LOCATION=$(curl -s "http://ip-api.com/json/$EXT")
fi

# Extract Country, State, and City (Handle Errors)
COUNTRY=$(echo "$LOCATION" | jq -r '.country // "Unavailable"')
REGION=$(echo "$LOCATION" | jq -r '.regionName // "Unavailable"')
CITY=$(echo "$LOCATION" | jq -r '.city // "Unavailable"')
# Get local Kali IP
KALI=$(hostname -I | awk '{print $1}')

# Print in table format
echo "---------------------------------"
printf "| %-12s | %-20s |\n" "Label" "Value"
echo "---------------------------------"
printf "| %-12s | %-20s |\n" "Public IP" "$EXT"
printf "| %-12s | %-20s |\n" "Country" "$COUNTRY"
printf "| %-12s | %-20s |\n" "State" "$REGION"
printf "| %-12s | %-20s |\n" "City" "$CITY"
printf "| %-12s | %-20s |\n" "Kali IP" "$KALI"
echo "---------------------------------"
echo

COUNT=$(wc -l < "$RESULTS_FILE")
echo -e "\e[31mTotal Onion Sites:\e[0m $COUNT"
chmod -R 777 "$PWD"
echo
# Darksheets Results
read -p "Open a darksheet with results y/n: " OPEN1
# Open spreadsheet with results
if [ "$OPEN1" == y ]
then
    echo -e "\e[031mOpening DarkSheets results with LibreOffice\e[0m"
    echo "Exit DarkSheets: CTRL + c"
    echo
# Open spreadsheet with all results
    echo "Opening DarkSheets with All Results"
    sudo qterminal -e libreoffice --calc "$PWD"/$RESULTS_FILE > /dev/null 2>&1 &
    echo
else
    echo "The $RESULTS_FILE have been saved to: "$PWD""
fi

# Open Firefox
echo -e "\e[031mPro Tip: Use NoScript on the Dark Web! Block Javascript!\e[0m"
read -p "Open Firefox to view results y/n: " OPEN2
echo
HIT1=$(awk 'FNR == 1 {print $1}' $RESULTS_FILE)
if [ "$OPEN2" == y ]
then
    echo "Opening Firefox with the First Result from DarkSheets"

sudo qterminal -e su -c "firefox $HIT1" kali > /dev/null 2>&1
    echo
    echo "To continue: CTRL + c"
else
    echo
fi

echo "DarkSheets script execution completed."
echo
echo "Friendly reminder to exit the Dark Web type: torghostng -x"
echo
# Ask the user if they want to disconnect from the dark web
read -p "Do you want to disconnect from dark web? (y/n): " DISCONNECT 

if [[ "$DISCONNECT" == "y" || "$DISCONNECT" == "Y" ]]; then
echo "⚡ Attempting to disconnect from the Dark Web..."

    echo
    echo "Exiting Dark Web"
    echo
    echo -e "\e[031mBack to the real world\e[0m"
    echo
    sudo torghostng -x

fi
echo

#Pay Me later
