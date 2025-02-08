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
# Todays Date
sudo timedatectl set-timezone America/Los_Angeles
echo -e "\e[034mToday is\e[0m"
date '+%Y-%m-%d %r' | tee darksheets-install.date
# Setting Variables
CITY=$(curl -s http://ip-api.com/line?fields=timezone | cut -d "/" -f 2)
PWD=$(pwd)
RED='\033[31m'
echo

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
# Verify Onion Links
OINFO=/opt/365/onion_verifier.py
if [ -f "$OINFO" ]
then
    echo -e "\e[031mFound Onion Verifier\e[0m"
else
    echo -e "\e[031mGetting Onion Verifier\e[0m"
    sudo cp /opt/365/onion_verifier.py $PWD
fi
echo

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
    echo -e "\e[031mFound for the Devil's Eye\e[0m"
else
    echo -e "\e[031mGetting the Devil\e[0m"
    sudo pipx install thedevilseye==2022.1.4.0 > /dev/null 2>&1
    echo
    echo "The Devil's in your computer"
fi
echo

# What are you researching?
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

# Create Results File
# Perform Devils Eye Search
RESULT_FILE="results+onions.txt"
echo "Saving results to $RESULT_FILE"
sudo /root/.local/share/pipx/venvs/thedevilseye/bin/eye -q "$SEARCH" | grep ".onion" > "$RESULT_FILE"
sed '/^invest/d' "$RESULT_FILE" > "$RESULT_FILE.tmp" && mv "$RESULT_FILE.tmp" "$RESULT_FILE"
sort -u "$RESULT_FILE" -o "$RESULT_FILE"
echo -e "\e[31mOnions Found:\e[0m $(wc -l < "$RESULT_FILE")"
echo

# Display 10 Results
head "$RESULT_FILE"
echo
echo "Saved results to "$PWD"/"$RESULT_FILE""
echo

# Check for TOR Connection
echo "Starting Tor service"
echo
sudo systemctl start tor

# Ask the user if they want to connect to the dark web
echo -e "\e[31mDo you want to connect to the dark web? (y/n): \e[0m"
read -r CONNECT

if [[ "$CONNECT" == "y" || "$CONNECT" == "Y" ]]; then
echo "⚡ Attempting to connect to the Dark Web..."
    
# Starting Tor with Netherlands
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
EXT=$(curl --socks5-hostname 127.0.0.1:9050 -s --max-time 4 https://check.torproject.org/api/ip)
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
echo -e "\e[031mVerifying Onion Links\e[0m"
sudo cp /opt/365/onion_verifier.py $PWD
# Simulated Progress Bar
echo -ne '#####                     (33%)\r'
sleep 1
echo -ne '#############             (66%)\r'
sleep 1
echo -ne '#######################   (100%)\r'
echo -ne '\n'
sudo python3 onion_verifier.py
echo
echo -e "\e[031mVerified Onion Results\e[0m"
VERIFIED_FILE="onion_titles.csv"
onion_count=$(wc -l < "$VERIFIED_FILE")
echo -e "\e[31mOnions Found:\e[0m $onion_count"

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
sudo qterminal -e libreoffice --calc "$PWD"/onion_titles.csv > /dev/null 2>&1
    echo
else
    echo "Maybe next time"
fi
    echo

# Open Firefox
echo -e "\e[031mOpen Firefox to view results y/n: \e[0m"
read -e OPEN2
echo
HIT1=$(awk 'FNR == 2 {print $2}' onion_titles.csv)
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
# Ask the user if they want to disconnect from the dark web
echo -e "\e[31mDo you want to disconnect from dark web? (y/n): \e[0m"
read -r DISCONNECT

if [[ "$DISCONNECT" == "y" || "$DISCONNECT" == "Y" ]]; then
echo "⚡ Attempting to disconnect from the Dark Web..."

    echo
    echo "Exiting Dark Web"
    echo
    sudo torghostng -x
    echo "Ok back to the real world"
fi
echo

echo "Exit Tor type: torghostng -x"
#Pay Me later
