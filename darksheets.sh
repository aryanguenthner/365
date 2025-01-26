#!/usr/bin/env bash

#######################################################
# Made for doing security research on the Dark Deep Web
# Intended to be used on Kali Linux
# Updated for compatibility and better Tor handling
#
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

# Setting Variables
KALI=$(hostname -I)
CITY=$(curl -s http://ip-api.com/line?fields=timezone | cut -d "/" -f 2)
EXT=$(curl -s api.ipify.org)
PWD=$(pwd)
echo

# Network Information
echo -e "\e[034mGetting Network Information\e[0m"
echo "Public IP: $EXT"
echo "Kali IP: $(echo "$KALI" | awk '{print $1}')"
echo

# Create Results File
RESULT_FILE="results+onions.txt"
echo -en "\e[034mWhat are you looking for: \e[0m"
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

# Perform Search
echo "Saving results to $RESULT_FILE..."
eye -q "$SEARCH" | grep ".onion" > "$RESULT_FILE"
sed '/^invest/d' "$RESULT_FILE" > "$RESULT_FILE.tmp" && mv "$RESULT_FILE.tmp" "$RESULT_FILE"
echo

# Display Results
echo -e "\e[033mTop Results\e[0m"
head "$RESULT_FILE"
echo "Saved results to $RESULT_FILE."
echo
# Ensure Tor is Installed and Running
if ! command -v tor >/dev/null; then
    echo "Tor is not installed. Installing..."
    sudo apt-get install -y tor
fi
echo

if ! systemctl is-active --quiet tor; then
    echo "Starting Tor service..."
    sudo systemctl start tor
fi

# Test Tor Connectivity
echo -e "\e[033mCheck Tor connectivity y/n: \e[0m"
read -r TOR
if [ "$TOR" == "y" ]; then
    tor_test=$(curl -x socks5h://127.0.0.1:9050 -s https://check.torproject.org/api/ip)
    if echo "$tor_test" | grep -q '"IsTor":true'; then
        echo "Tor is working. IP: $(echo "$tor_test" | jq -r '.IP')"
    else
        echo "Tor connection failed. Exiting."
        exit 1
    fi
else
    echo "Skipping Tor connectivity check."
fi
echo
# Install TorGhost
install_torghost() {
    echo "Installing TorGhost..."
    if [ ! -d "/opt/torghost" ]; then
        sudo apt-get install -y python3-pip
        sudo pip3 install stem
        cd /opt || exit
        sudo git clone https://github.com/aryanguenthner/torghost.git
        cd torghost || exit
        sudo ./build.sh
        echo "TorGhost installed successfully."
    else
        echo "TorGhost is already installed."
    fi
}

# Ensure TorGhost is Installed
install_torghost

# Switch to a New Tor Circuit using TorGhost
new_tor_circuit_torghost() {
    echo "Requesting a new Tor circuit using TorGhost..."
    sudo python3 /opt/torghost/torghost.py -r
    if [ $? -eq 0 ]; then
        echo "New Tor circuit established with TorGhost."
    else
        echo "Failed to switch Tor circuit with TorGhost."
    fi
}

# Request New Tor Circuit
new_tor_circuit_torghost

# Exit Tor
echo -n 'Exit the Dark Web y/n: '
read DWEB1
if [ "$DWEB1" == "y" ]; then
    echo "Exiting Tor..."
    sudo systemctl stop tor
    echo "Tor exited successfully."
else
    echo "Tor remains active."
fi

echo "DarkSheets script execution completed."
