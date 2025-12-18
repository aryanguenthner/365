#!/usr/bin/env bash
printf '\033]0;%s\007' "DarkFox"

#######################################################
# Made for CTI OSINT cyber security research on the Dark Deep Web
# Intended to be used on Kali Linux
# Updated for compatibility and better Tor handling
# Hacked on 12/17/2025, pay me later
# Great ideas
# Maybe run darkfox two times to make sure everything is installed.
# Go here --> https://addons.mozilla.org/en-US/firefox/addon/noscript/
# install_addon "https://addons.mozilla.org/firefox/downloads/file/4141345/noscript-11.4.26.xpi" "noscript"
# install_addon "https://addons.mozilla.org/firefox/downloads/file/4125998/adblock_plus-3.17.1.xpi" "adblock_plus"
# install_addon "https://addons.mozilla.org/firefox/downloads/file/4151024/sponsorblock-5.4.15.xpi" "sponsorblock"
# install_addon "https://addons.mozilla.org/firefox/downloads/file/4329214/easy_auto_refresh-5.6.xpi" "easy auto refresh"
# Good to know: https://github.com/aryanguenthner/deepdarkCTI/blob/main/ransomware_gang.md

######################################################

# Banner
    cat <<'EOF'
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║   ██████╗  █████╗ ██████╗ ██╗  ██╗███████╗ ██████╗ ██╗  ██╗ ║
║   ██╔══██╗██╔══██╗██╔══██╗██║ ██╔╝██╔════╝██╔═══██╗╚██╗██╔╝ ║
║   ██║  ██║███████║██████╔╝█████╔╝ █████╗  ██║   ██║ ╚███╔╝  ║
║   ██║  ██║██╔══██║██╔══██╗██╔═██╗ ██╔══╝  ██║   ██║ ██╔██╗  ║
║   ██████╔╝██║  ██║██║  ██║██║  ██╗██║     ╚██████╔╝██╔╝ ██╗ ║
║   ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝      ╚═════╝ ╚═╝  ╚═╝ ║
║                                                              ║
║            CTI Cyber Threat Intelligence Tool                ║
║                  Dark Web OSINT Research                     ║
║                        Version 2.0                           ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
EOF
echo "OSINT CTI Cyber Threat intelligence v1.2"
# DarkFox is meant for researchers and educational purposes only. This was developed to speed the investigation, enable clear documentation without pain and suffering. Pay me later.
# Consider using spiderfoot
# Find something good let me know
# https://github.com/smicallef/spiderfoot

echo
# Todays Date
sudo timedatectl set-timezone America/Los_Angeles
echo -e "\e[034mToday is\e[0m"
date '+%Y-%m-%d %r' | tee darkfox.run.date
# Setting Variables
CITY=$(curl -s http://ip-api.com/line?fields=timezone | cut -d "/" -f 2)
PWD=$(pwd)
GREEN=032m
YELLOW=033m
RED=031m
RED='\033[31m'
BLUE=034m
echo

# Keep the screen on during investigations
xset s off            # Disable screensaver
xset s noblank        # No screen blanking
xset -dpms            # Disable DPMS power saving

# Dependencies Check
# Must have LibreOffice,TheDevilsEye,Tor,TorGhost,OnionVerifier,FireFox,Chrome Brwoser, GoWitness
echo "Checking Requirements, Chill for a sec"
echo
sudo apt-get update > /dev/null 2>&1
LOGFILE="/var/log/kali_apt_install_errors.log"
PACKAGES=( jq tor torbrowser-launcher python3-stem libreoffice )

echo "Starting package installs..."
echo
echo "Errors will be logged to: $LOGFILE"
echo "" > "$LOGFILE"

for pkg in "${PACKAGES[@]}"; do
    # Check if the package is already installed
    if dpkg -s "$pkg" >/dev/null 2>&1; then
        echo -e "\e[33m[SKIP]\e[0m $pkg is already installed."
    else
        echo -e "\e[32m[INSTALLING]\e[0m $pkg..."
        
        # Try to install
        if ! apt-get -y install "$pkg"; then
            echo "[ERROR] Failed to install: $pkg" | tee -a "$LOGFILE"
            echo -e "\e[31m[FAILED]\e[0m Could not install $pkg"
        fi
    fi
done

# Add Desktop Launcher
LAUNCHER_SOURCE="/opt/darkfox/DarkFox.desktop"
LAUNCHER_DEST="/home/kali/Desktop/DarkFox.desktop"

# Check if the file exists using the -f flag
if [ -f "$LAUNCHER_DEST" ]; then
    echo "DarkFox launcher already exists on Desktop. Skipping..."
else
    echo "Adding DarkFox launcher to Desktop..."
    cp "$LAUNCHER_SOURCE" "$LAUNCHER_DEST"
    
    # Ensure we target the file we just copied
    chmod 777 "$LAUNCHER_DEST"
fi 
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

echo
echo "Done! Check $LOGFILE for anything that failed."
echo

sudo apt-get autoremove -y && updatedb > /dev/null 2>&1

# Simulated Progress Bar
echo -ne '#####                     (33%)\r'
sleep 1
echo -ne '#############             (66%)\r'
sleep 1
echo -ne '#######################   (100%)\r'
echo -ne '\n'
echo

# Create OSINT investigations folder
mkdir -p $(pwd)/investigations

# Verify LibreOffice is installed
L="/usr/bin/libreoffice"
if [ -f "$L" ]
then
    echo -e "\e[031mFound LibreOffice\e[0m"
else
    echo -e "\e[031mPlease wait while LibreOffice is installed\e[0m"
    sudo apt-get install -y libreoffice
fi
echo

cd /home/kali/Downloads || exit 1

# Google Chrome Installer
GC="/usr/bin/google-chrome-stable"
if [ -f "$GC" ]; then
    echo -e "\e[031mFound Google Chrome\e[0m"

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
echo

mkdir -p /opt/darkfox
DARKFOX_DIR="/opt/darkfox"
cd  $DARKFOX_DIR || exit 1
# Verify gowitness 3.0.5 is in /opt/darkfox
GOWIT="/opt/darkfox/gowitness"
if [ -f "$GOWIT" ]
then
    echo -e "\e[031mFound GoWitness 3.0.5\e[0m"
else
    echo -e "\e[031mDownloading Missing GoWitness 3.0.5\e[0m"
    wget --no-check-certificate -O gowitness 'https://drive.google.com/uc?export=download&id=1C-FpaGQA288dM5y40X1tpiNiN8EyNJKS' # gowitness 3.0.5
    chmod a+x gowitness
fi
echo

# Onion Verifier
# Verify gowitness 3.0.5 is in /opt/darkfox
OV="/opt/darkfox/onion_verifier.py"
if [ -f "$OV" ]
then
    echo -e "\e[031mFound Onion Verifier\e[0m"
else
    echo -e "\e[031mDownloading Onion Verifier\e[0m"
    wget --no-check-certificate -O onion_verifier.py 'https://github.com/aryanguenthner/darkfox/raw/refs/heads/main/onion_verifier.py'
    chmod a+x onion_verifier.py
fi
echo

# Verify TorGhost is installed
TORNG="/usr/bin/torghostng"

if [ -f "$TORNG" ]; then
    echo -e "\e[031mFound TorghostNG\e[0m"
else
    echo -e "\e[33mInstalling TorghostNG...\e[0m"
    
    # 1. Clean up previous failed installs to prevent "destination exists" git errors
    if [ -d "/opt/torghostng" ]; then
        echo "Removing broken/old /opt/torghostng directory..."
        sudo rm -rf /opt/torghostng
    fi

    # 2. Clone the repo
    sudo git clone https://github.com/aryanguenthner/torghostng /opt/torghostng
    cd /opt/torghostng || exit

    # 3. Pre-install dependencies via APT to bypass PIP restrictions (PEP 668)
    # This prevents install.py from crashing when it tries to use pip
    echo "Installing Python dependencies via APT..."
    sudo apt-get install -y python3-requests python3-stem python3-packaging

    # 4. Ensure sysctl.conf exists
    if [ ! -f /etc/sysctl.conf ]; then
        sudo touch /etc/sysctl.conf
    fi

    # 5. Run the installer
    sudo chmod +x install.py
    sudo python3 install.py

    # 6. Fallback Verification: If the bin file wasn't created, force create the link
    if [ ! -f "/usr/bin/torghostng" ]; then
        echo "Standard install failed, forcing manual symlink..."
        sudo ln -sf /opt/torghostng/torghostng.py /usr/bin/torghostng
        sudo chmod +x /usr/bin/torghostng
    fi

    echo "TorghostNG installation attempt complete."
fi
echo

# Check/Install pyahmia
PYAHMIA_BIN="/root/.local/bin/pyahmia"
if [ -x "$PYAHMIA_BIN" ] && "$PYAHMIA_BIN" -v &> /dev/null; then
    echo -e "\e[31mFound pyahmia\e[0m" # Green for success
else
    echo -e "\e[31mPyahmia not found. Installing via pipx...\e[0m"
    pipx install pyahmia
    
    # Verify installation was successful
    if [ -x "$PYAHMIA_BIN" ]; then
        echo -e "\e[31mConfirmed pyahmia installed successfully\e[0m"
    else
        echo -e "\e[31mWarning: pyahmia installation may have failed\e[0m"
        exit 1
    fi
    echo
fi


# Editing Firefox about:config this allows DarkWeb .onion links to be opened with Firefox
#echo 'user_pref("network.dns.blockDotOnion", false);' > user.js
#sudo mv user.js /home/kali/.mozilla/firefox/*default-esr/
# Create the files without having to run firefox for the first time.
# Launch Firefox to auto-create the profile, then kill it
FIREFOX_DIR="/home/kali/.mozilla/firefox"

if [ ! -d "$FIREFOX_DIR" ]; then
    echo "[+] Firefox profile not found. Initializing..."
    sudo -u kali firefox --headless >/dev/null 2>&1 &
    sleep 3
    sudo pkill firefox
fi

USER_JS_PATH=$(find /home/kali/.mozilla/firefox/ -name "user.js" 2>/dev/null | head -n 1)
if [[ -f "$USER_JS_PATH" ]]; then
    if ! grep -q 'user_pref("network.dns.blockDotOnion", false);' "$USER_JS_PATH"; then
        echo 'user_pref("network.dns.blockDotOnion", false);' >> "$USER_JS_PATH"
    fi
else
    sudo -u kali firefox >/dev/null 2>&1 &
    sleep 2
    sudo pkill firefox
    echo 'user_pref("network.dns.blockDotOnion", false);' > user.js
    sudo mv user.js /home/kali/.mozilla/firefox/*default-esr/
fi
echo
echo -ne '#######################\r'
echo

echo
echo "Mozilla can actually go on the DarkWeb, Use Torbrowser first"
# --- Configure Firefox to allow .onion sites ---
echo "[+] Configuring Firefox to allow .onion sites..."
# Create the policies directory if it doesn't exist
# Note: Kali uses Firefox ESR by default. Adjust path if using standard Firefox.
FIREFOX_POLICY_DIR="/etc/firefox-esr/policies"
mkdir -p "$FIREFOX_POLICY_DIR"
# Write the policies.json file
cat <<EOF > "$FIREFOX_POLICY_DIR/policies.json"
{
  "policies": {
    "Preferences": {
      "network.dns.blockDotOnion": {
        "Value": false,
        "Status": "locked"
      }
    }
  }
}
EOF
echo "[+] Firefox policy applied: network.dns.blockDotOnion = false"
echo

echo
echo "Config Looks Good So Far"
echo
echo "Working directory: $(pwd)"
echo -ne '\n'

# User Input
read -e -p "What are you researching: " SEARCH

# Ahmia saves results to /root/pyahmia/{SEARCH}.csv
AHMIA_CSV="/root/pyahmia/${SEARCH}.csv"
RESULTS_FILE="/root/pyahmia/${SEARCH}.txt"

echo -e "\nSearching for: $SEARCH"
echo

# Progress Bar
echo "Searching for DarkWeb Onions..."
echo -ne '#####                     (33%)\r'
sleep 1
echo -ne '#############             (66%)\r'
sleep 1
echo -ne '#######################   (100%)\r'
echo -ne '\n'
echo

# Execution and Filtering
echo "Querying Ahmia..."

# Run pyahmia - it will save to /root/pyahmia/{SEARCH}.csv
/root/.local/bin/pyahmia -e "$SEARCH" > /dev/null 2>&1

# Check if the CSV file was created
if [ -f "$AHMIA_CSV" ]; then
    # Extract .onion URLs from the CSV (column 3 contains the URLs)
    # Skip header (NR > 1) and extract only valid .onion domains
    awk -F',' 'NR > 1 {
        # Extract .onion URL from the field
        if ($3 ~ /\.onion/) {
            # Remove quotes and extract just the onion domain
            url = $3
            gsub(/"/, "", url)
            gsub(/^[ \t]+|[ \t]+$/, "", url)
            if (url ~ /\.onion$/) {
                print url
            }
        }
    }' "$AHMIA_CSV" | sort -u > "$RESULTS_FILE"
    
    # Additional filtering - remove banned patterns
    sed -i '/invest/d; /222/d; /drug/d; /porn/d' "$RESULTS_FILE"
    
    COUNT=$(wc -l < "$RESULTS_FILE")
    echo -e "\e[31mOnions Found:\e[0m $COUNT"
    echo "Results saved to: $RESULTS_FILE"
    echo "CSV source: $AHMIA_CSV"
else
    echo -e "\e[31mNo CSV file created. Ahmia may have failed.\e[0m"
    COUNT=0
fi
echo

# CHECK IF RESULTS EXIST - CONDITIONAL TOR CONNECTION
if [ "$COUNT" -eq 0 ]; then
    echo -e "\e[31m======================================\e[0m"
    echo -e "\e[31mNo onion links found for: $SEARCH\e[0m"
    echo -e "\e[31m======================================\e[0m"
    echo
    read -p "Would you like to search for something else? (y/n): " SEARCH_AGAIN
    echo
    
    if [[ "$SEARCH_AGAIN" == "y" || "$SEARCH_AGAIN" == "Y" ]]; then
        # Restart the search process
        read -p "What are you researching: " SEARCH
        AHMIA_CSV="/root/pyahmia/${SEARCH}.csv"
        RESULTS_FILE="/root/pyahmia/${SEARCH}.txt"
        
        echo -e "\nSearching for: $SEARCH"
        echo
        
        echo "Searching for DarkWeb Onions..."
        echo -ne '#####                     (33%)\r'
        sleep 1
        echo -ne '#############             (66%)\r'
        sleep 1
        echo -ne '#######################   (100%)\r'
        echo -ne '\n'
        echo
        
        echo "Querying Ahmia..."
        /root/.local/bin/pyahmia -e "$SEARCH" > /dev/null 2>&1
        
        if [ -f "$AHMIA_CSV" ]; then
            # Extract .onion URLs from CSV
            awk -F',' 'NR > 1 {
                if ($3 ~ /\.onion/) {
                    url = $3
                    gsub(/"/, "", url)
                    gsub(/^[ \t]+|[ \t]+$/, "", url)
                    if (url ~ /\.onion$/) {
                        print url
                    }
                }
            }' "$AHMIA_CSV" | sort -u > "$RESULTS_FILE"
            
            sed -i '/invest/d; /222/d; /drug/d; /porn/d; /fresh/d' "$RESULTS_FILE"
            
            COUNT=$(wc -l < "$RESULTS_FILE")
            echo -e "\e[31mOnions Found:\e[0m $COUNT"
            echo "Results saved to: $RESULTS_FILE"
        else
            echo -e "\e[31mNo CSV file created.\e[0m"
            COUNT=0
        fi
        echo
    else
        echo -e "\e[31mExiting script. No results to process.\e[0m"
        exit 0
    fi
fi

# Debugging - show preview
if [ "$COUNT" -gt 0 ]; then
    echo "Preview of found onions:"
    head -3 "$RESULTS_FILE"
    echo
fi
echo

# ONLY PROCEED TO TOR CONNECTION IF COUNT > 0
if [ "$COUNT" -gt 0 ]; then
    echo -e "\e[32m======================================\e[0m"
    echo -e "\e[32mFound $COUNT onion links. Proceeding...\e[0m"
    echo -e "\e[32m======================================\e[0m"
    echo
    
    # Check for TOR Connection
    echo "Starting Tor service"
    sudo systemctl start tor
    echo
    
    # Starting Tor in the Netherlands
    # Example Country Codes: nl,cz,de,us,ca,mx,ru,br,bo,gb,fr,ir,by,cn
    echo "Attempting to connect to the Dark Web..."

    # --- FIX: Create sysctl.conf if missing to prevent TorGhost crash ---
    if [ ! -f /etc/sysctl.conf ]; then
        echo "[Fix] Creating missing /etc/sysctl.conf..."
        sudo touch /etc/sysctl.conf
    fi
    # --------------------------------------------------------------------

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
    echo -e "\e[31mGetting More Info on $COUNT Onions\e[0m"
    echo "---------------------------------"
    echo
    
else
    echo -e "\e[31mNo onion links available. Cannot proceed.\e[0m"
    exit 1
fi
echo

# After COUNT is determined and > 0, before running onion_verifier:

# CRITICAL: Set up the file that onion_verifier.py expects
cd "$DARKFOX_DIR" || exit 1

# Copy results to the format/location onion_verifier.py expects
cp "$RESULTS_FILE" "$DARKFOX_DIR/results.onion.csv"

echo "Copied results to: $DARKFOX_DIR/results.onion.csv"
echo

# Verify the file exists and has content
if [ ! -f "$DARKFOX_DIR/results.onion.csv" ]; then
    echo -e "\e[31mERROR: Could not create results.onion.csv\e[0m"
    exit 1
fi
echo

VERIFY_COUNT=$(wc -l < "$DARKFOX_DIR/results.onion.csv")
echo "File contains $VERIFY_COUNT lines"
echo

# Now run onion_verifier
echo -e "\e[031m[+] Verifying Onions...\e[0m"
echo
cd "$DARKFOX_DIR" || exit 1
sudo python3 "$DARKFOX_DIR/onion_verifier.py" "$DARKFOX_DIR/results.onion.csv" | tee "$DARKFOX_DIR/onion_verifier.log"
echo

# Open spreadsheet with all results
echo -e "\e[031mOpening DarkFox results with LibreOffice\e[0m"
ONIONS="$DARKFOX_DIR/onion_page_titles.csv"

if [ -f "$ONIONS" ]; then
    sudo libreoffice --calc "$ONIONS" --infilter="CSV:44,34,0,1,4/2/1" --norestore > /dev/null 2>&1 & disown
    echo "The Onions have been saved to: $ONIONS"
else
    echo "Warning: $ONIONS not found yet. It may be created after gowitness finishes."
fi
echo

# Open Firefox
echo -e "\e[031mPro Tip: Use NoScript on the Dark Web! Block Javascript!\e[0m"
echo

HITS=()

if [ -f "$ONIONS" ]; then
    # File exists: Extract top 3 based on Title relevance
    readarray -t HITS < <(awk -v search="$SEARCH" '
        BEGIN { count = 0 }
        NR > 1 && $1 ~ /\.onion/ {
            url = $1;
            sub(/\.onion.*/, ".onion", url);

            title = tolower($2);
            search_lower = tolower(search);

            score = 0;
            if (index(title, search_lower)) { score += 10 }
            if (index(url, search_lower)) { score += 5 }

            results[url] = score;
        }
        END {
            PROCINFO["sorted_in"] = "@val_num_desc"
            for (url in results) {
                print url
                if (++n == 3) break
            }
        }
    ' "$ONIONS")

elif [ -f "$DARKFOX_DIR/results.onion.csv" ]; then
    # File missing: Fallback to the raw list of URLs
    echo -e "\e[33mWarning: Titles file not found. Falling back to raw URL list.\e[0m"
    readarray -t HITS < <(head -n 3 "$DARKFOX_DIR/results.onion.csv")

else
    echo -e "\e[31mNo results files found to open.\e[0m"
fi

# Assign extracted values (fallback to empty string if fewer than 3)
HITS=("${HITS[@]:0:3}")  # Keep only the first 3 elements
echo "Opening Dark Web Sites in Firefox"
echo
for HIT in "${HITS[@]}"; do
    [ -n "$HIT" ] && 
    sudo -u kali firefox "$HIT" > /dev/null 2>&1 & disown
    sleep 2
done

# Run gowitness with optimized flags
    echo -e "\e[31mGoWitness Getting Screenshots, Be patient and let it run.\e[0m"
echo
sudo ./gowitness scan file -f "$DARKFOX_DIR/results.onion.csv" \
    --threads 16 \
    --write-db \
    --screenshot-fullpage \
    --chrome-proxy socks5://127.0.0.1:9050 \
    2>&1 | grep -Ev "ERROR|unknown IPAddressSpace value: Loopback"

    
echo
echo -e "\e[31mScreenshot capture complete\e[0m"
echo

# Debugging (optional)
printf "\n%s\n" "${HITS[@]}"
echo

# After results have been saved to db, Start Web Server
echo "Starting GoWitness Server, Open http://127.0.0.1:7171/ when the screenshots are ready"
sudo qterminal -e ./gowitness report server > /dev/null 2>&1 & disown
echo

# After the web server has started, Open Firefox to see the results
    echo -e "\e[031mOpening GoWitness Results in Firefox\e[0m"
echo
GOSERVER="http://127.0.0.1:7171/gallery"
sudo -u kali firefox $GOSERVER > /dev/null 2>&1 & disown

# Give Firefox a moment to load the Gowitness Server
sleep 2

# Refresh Firefox tab
sudo xdotool search --onlyvisible --class firefox windowactivate --sync key Ctrl+r


# Ask the user if they want to disconnect from the dark web
echo "Friendly reminder: to exit the Dark Web manually, type: torghostng -x"
echo
read -p "Do you want to disconnect from the dark web? (y/n): " DISCONNECT
echo

if [[ "$DISCONNECT" == "y" || "$DISCONNECT" == "Y" ]]; then
    echo
    echo "Attempting to disconnect from the Dark Web..."
    echo
    echo "Exiting Dark Web"
    echo -e "\e[31mBack to the real world\e[0m"
    echo
    sudo torghostng -x --dns
fi
echo

# Pay Me later
