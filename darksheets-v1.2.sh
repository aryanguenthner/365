#!/usr/bin/env bash

#######################################################
# Made for OSINT CTI cyber security research on the Dark Deep Web
# Intended to be used on Kali Linux
# Updated for compatibility and better Tor handling
# Hacked on 03/09/2025, pay me later
# Great ideas
# Go here --> https://addons.mozilla.org/en-US/firefox/addon/noscript/
# install_addon "https://addons.mozilla.org/firefox/downloads/file/4141345/noscript-11.4.26.xpi" "noscript"
# install_addon "https://addons.mozilla.org/firefox/downloads/file/4125998/adblock_plus-3.17.1.xpi" "adblock_plus"
# install_addon "https://addons.mozilla.org/firefox/downloads/file/4151024/sponsorblock-5.4.15.xpi" "sponsorblock"
# install_addon "https://addons.mozilla.org/firefox/downloads/file/4329214/easy_auto_refresh-5.6.xpi" "easy auto refresh"

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
# Consider using spiderfoot
# Find something good let me know
# https://github.com/smicallef/spiderfoot

echo
# Todays Date
sudo timedatectl set-timezone America/Los_Angeles
echo -e "\e[034mToday is\e[0m"
date '+%Y-%m-%d %r' | tee darksheets.run.date
# Setting Variables
CITY=$(curl -s http://ip-api.com/line?fields=timezone | cut -d "/" -f 2)
PWD=$(pwd)
RED='\033[31m'
echo

# Network Information
echo -e "\e[031mGetting Network Information\e[0m"
# Get public IP, Before Connecting to Dark Web
# Get location details using ipinfo.io
# Fetch Public IP using multiple sources (fallback if one fails)
EXT=$(curl -s https://api64.ipify.org || curl -s https://ifconfig.me || curl -s https://checkip.amazonaws.com)

# If IP is still empty, set a default message
# If "jq: parse error: Invalid numeric literal at line 3, column 0"
# then you are already connected to Tor
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
# Must have LibreOffice,TheDevilsEye,Tor,TorGhost,OnionVerifier,FireFox,Chrome Brwoser, GoWitness
echo "Checking Requirements"
sudo apt-get install -y jq tor torbrowser-launcher python3-stem libreoffice > /dev/null 2>&1
# Simulated Progress Bar
echo -ne '#####                     (33%)\r'
sleep 1
echo -ne '#############             (66%)\r'
sleep 1
echo -ne '#######################   (100%)\r'
echo -ne '\n'

# Download Apps
cd /home/kali/Downloads || exit 1
# Google Chrome Installer
GC="/usr/bin/google-chrome-stable"
if [ -f "$GC" ]; then
    echo -e "\e[031mFound Google Chrome\e[0m"
    echo
else
    echo "Google Chrome not found. Installing..."
    # Remove unnecessary packages and update database (optional)
    sudo apt-get autoremove -y

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
fi

# DarkSheets /opt/ds
cd /opt/365 || exit 1
# Verify gowitness 3.0.5 is in /opt/ds
GOWIT=/opt/ds/gowitness
if [ -f "$GOWIT" ]
then
    echo -e "\e[031mFound GoWitness 3.0.5\e[0m"
else
    echo -e "\e[031mDownloading Missing GoWitness 3.0.5\e[0m"
    wget --no-check-certificate -O /opt/365/gowitness 'https://drive.google.com/uc?export=download&id=1C-FpaGQA288dM5y40X1tpiNiN8EyNJKS' # gowitness 3.0.5
    chmod -R 777 /opt/365
fi
echo

# Onion Verifier
OV=onion_verifier.py
if [ -f "$OV" ]
then
    echo -e "\e[031mFound Onion Verifier\e[0m"
else
    echo -e "\e[031mDownloading Onion Verifier\e[0m"
    wget --no-check-certificate -O onion_verifier.py 'https://github.com/aryanguenthner/ds/raw/refs/heads/main/onion_verifier.py'
    chmod -R 777 onion_verifier.py
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
echo

# Verify TorGhost is installed
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
    pipx install thedevilseye==2022.1.4.0 > /dev/null 2>&1
    echo
    echo "The Devil's in your computer"
fi
echo -ne '#######################\r'
echo

# Editing Firefox about:config this allows DarkWeb .onion links to be opened with Firefox
#echo 'user_pref("network.dns.blockDotOnion", false);' > user.js
#sudo mv user.js /home/kali/.mozilla/firefox/*default-esr/
USER_JS_PATH=$(find /home/kali/.mozilla/firefox/ -name "user.js" | head -n 1)
# Fix Firefox for Dark Web
if [[ -f "$USER_JS_PATH" ]]; then
    if ! grep -q 'user_pref("network.dns.blockDotOnion", false);' "$USER_JS_PATH"; then
        echo 'user_pref("network.dns.blockDotOnion", false);' >> "$USER_JS_PATH"
    fi
else
    echo 'user_pref("network.dns.blockDotOnion", false);' > user.js
    sudo mv user.js /home/kali/.mozilla/firefox/*default-esr/
fi
echo

echo "Config Looks Good So Far"
echo -ne '\n'

# Create OSINT Folder
mkdir -p $(pwd)/osint-notes

# What are you researching?
read -p "What are you researching: " SEARCH
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
RESULTS_FILE=results.onion.csv
sudo /root/.local/share/pipx/venvs/thedevilseye/bin/eye -q "$SEARCH" | grep ".onion" > "$RESULTS_FILE"
sed '/^invest/d; /^222/d; /^drug/d; /^porn/d; /\.onion$/!d' "$RESULTS_FILE" > "$RESULTS_FILE.tmp" && mv "$RESULTS_FILE.tmp" "$RESULTS_FILE"
sort -u "$RESULTS_FILE" -o "$RESULTS_FILE"
echo -e "\e[31mOnions Found:\e[0m $(wc -l < "$RESULTS_FILE")"
echo

# Display 10 Results
head "$RESULTS_FILE"
echo
echo "Saved results to ""$PWD""/"$RESULTS_FILE""
echo
# Check for TOR Connection
echo "Starting Tor service"
sudo systemctl start tor
echo

# Starting Tor in the Netherlands
# Example Country Codes: nl,de,us,ca,mx,ru,br,bo,gb,fr,ir,by,cn
echo "Attempting to connect to the Dark Web..."
sudo torghostng -id nl
echo
echo -e "\e[031mEstablishing a Connection to the Dark Web\e[0m"
    
# Simulated Progress Bar
echo -ne '#####                     (33%)\r'
sleep 1
echo -ne '#############             (66%)\r'
sleep 1
echo -ne '#######################   (100%)\r'
sleep 1
echo -ne '\n'
echo
echo -e "\e[31mConnection Established. You can now access .onion sites.\e[0m"

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
chmod -R 777 "$PWD"
COUNT=$(wc -l < "$RESULTS_FILE")
echo -e "\e[31mGetting More Info on $COUNT Onions\e[0m"
echo "---------------------------------"
echo
cd /opt/ds || exit 1
sudo python3 onion_verifier.py | tee onion_verifier.log
echo

# Get Screenshot, Save results to db
echo "GoWitness Getting Screenshots, Be patient and let it run"
sudo qterminal -e ./gowitness scan file -f "$RESULTS_FILE" --threads 10 --write-db --chrome-proxy socks5://127.0.0.1:9050 > /dev/null 2>&1 & disown
echo

# Open spreadsheet with all results
echo -e "\e[031mOpening DarkSheets results with LibreOffice\e[0m"
ONIONS=onion_page_titles.csv
sudo libreoffice --calc "$ONIONS" --infilter=”CSV:44,34,0,1,4/2/1” --norestore > /dev/null 2>&1 & disown
echo
echo "The Onions have been saved to: ""$PWD""/"$ONIONS""
echo
# Open Firefox
echo -e "\e[031mPro Tip: Use NoScript on the Dark Web! Block Javascript!\e[0m"
echo

# Extract top 3 unique .onion URLs matching the search query
readarray -t HITS < <(awk -v search="$SEARCH" '
    BEGIN { count = 0 }
    NR > 1 && $1 ~ /\.onion/ {  # Skip header, process .onion URLs
        url = $1;
        sub(/\.onion.*/, ".onion", url);  # Keep only the .onion domain
        
        title = tolower($2);
        search_lower = tolower(search);

        score = 0;
        if (index(title, search_lower)) { score += 10 }  # Strong match in title
        if (index(url, search_lower)) { score += 5 }      # Some match in URL

        results[url] = score;
    }
    END {
        # Sort results by score (descending) and print top 3 unique URLs
        n = 0;
        PROCINFO["sorted_in"] = "@val_num_desc"
        for (url in results) {
            print url
            if (++n == 3) break
        }
    }
' "$ONIONS")

# Assign extracted values (fallback to empty string if fewer than 3)
HITS=("${HITS[@]:0:3}")  # Keep only the first 3 elements
echo "Opening Dark Web Sites in Firefox"
echo
for HIT in "${HITS[@]}"; do
    [ -n "$HIT" ] && 
    sudo -u kali firefox "$HIT" > /dev/null 2>&1 & disown
done

# Debugging (optional)
printf "\n%s\n" "${HITS[@]}"
echo

# After results have been saved to db, Start Web Server
echo "Starting GoWitness Server, Open http://127.0.0.1:7171/ when the screenshots are ready"
sudo qterminal -e ./gowitness report server > /dev/null 2>&1 & disown
echo

# After the web server has started, Open Firefox to see the results
echo "Opening GoWitness Results in Firefox"
echo
GOSERVER="http://127.0.0.1:7171/gallery"
sudo -u kali firefox $GOSERVER > /dev/null 2>&1 & disown

# Ask the user if they want to disconnect from the dark web
echo "Friendly reminder to exit the Dark Web type: torghostng -x"
echo
read -p "Do you want to disconnect from the dark web? (y/n): " DISCONNECT 
echo
if [[ "$DISCONNECT" == "y" || "$DISCONNECT" == "Y" ]]; then
echo
echo "Attempting to disconnect from the Dark Web..."
    
    echo "Exiting Dark Web"
    echo
    echo -e "\e[031mBack to the real world\e[0m"
    echo
    sudo torghostng -x

fi
echo

#Pay Me later
