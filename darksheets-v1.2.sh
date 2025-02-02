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
echo "v1.2"
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
# Get public IP
EXT=$(dig +short myip.opendns.com @resolver1.opendns.com)
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

echo -e "\e[031mLooking for the Devil's Eye\e[0m"
echo
# Verify the Devil exists
#E=/usr/local/bin/eye
E=/root/.local/share/pipx/venvs/thedevilseye/bin/eye
if [ -f "$E" ]
then

    echo -e "\e[031mFound for the Devil's Eye\e[0m"

else

    echo -e "\e[031mGetting the Devil\e[0m"
    sudo pipx install thedevilseye==2022.1.4.0
    echo

echo "The Devil's in your computer"
fi
echo

# Create Results File
RESULT_FILE="results+onions.txt"
echo -en "\e[031mWhat are you looking for: \e[0m"
read -e SEARCH
echo

# Simulate Progress Bar
echo "Searching..."
echo -ne '#####                     (33%)\r'
sleep 1
echo -ne '#############             (66%)\r'
sleep 1
echo -ne '#######################   (100%)\r'
echo -ne '\n'
echo

# Perform Devils Eye Search
echo "Saving results to $RESULT_FILE..."
sudo /root/.local/share/pipx/venvs/thedevilseye/bin/eye -q "$SEARCH" | grep ".onion" > "$RESULT_FILE"
sed '/^invest/d' "$RESULT_FILE" > "$RESULT_FILE.tmp" && mv "$RESULT_FILE.tmp" "$RESULT_FILE"
echo

# Display Results
echo -e "\e[031mTop Results\e[0m"
head "$RESULT_FILE"
echo
echo "Saved results to $RESULT_FILE."
echo

# Darksheets Results
echo -e "\e[031mOpen a darksheet with results y/n: \e[0m"
read OPEN1
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

    echo "Close terminal press: CTRL + c"
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

# Install TorGhost
TOR=/usr/bin/torghost/torghost.py
if [ -f "$TOR" ]
then
    echo "Torghost is already installed."
    echo
else
    echo "Downloading & Installing TorGhost"
wget -c --no-check-certificate https://github.com/aryanguenthner/TorGhost/releases/download/v3.1.1/torghost_3.1.1.deb
    sudo dpkg -i torghost_3.1.1.deb
    sudo chmod +x /usr/bin/torghost/torghost.py
    sudo chown root:root /usr/bin/torghost/torghost.py

fi
    echo

# Ask the user if they want to connect to the dark web
read -p "Do you want to connect to the dark web? (y/N): " choice
echo
[[ "$choice" =~ ^[Yy]$ ]] && sudo python3 /usr/bin/torghost/torghost.py -s > /dev/null 2>&1
echo
# Get Dark Web IP
EXT=$(dig +short myip.opendns.com @resolver1.opendns.com)

# Get country using ipinfo.io
COUNTRY=$(curl -s ipinfo.io/country)

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
# Open FF
echo -e "\e[033mOpen Firefox to view results y/n: \e[0m"
read -e OPEN2
echo

HIT1=$(awk 'FNR == 1 {print $1}' results+onions.txt)
if [ "$OPEN2" == y ]
then
    echo "Opening Firefox with data from DarkSheets"
    echo
sudo qterminal -e su -c "firefox $HIT1" kali > /dev/null 2>&1
    echo
    echo "To continue: CTRL + c"
    echo
    echo "To exit:     CTRL + c"
else

    echo "Maybe next time"

fi
    echo

# Exit Tor
echo -n 'Exit the Dark Web y/n: '
echo
read DWEB1
if [ "$DWEB1" == "y" ]; then
    echo "Exiting Tor..."
    echo
    sudo systemctl stop tor
    echo "Tor exited successfully."
    echo
else
    echo "Tor remains active."
fi

echo "DarkSheets script execution completed."
echo
