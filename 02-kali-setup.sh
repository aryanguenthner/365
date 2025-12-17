#!/usr/bin/env zsh

################################################
# Kali Linux Blue Team, Red Team, OSINT CTI, Setup Automation Script
# Last Updated 12/17/2025, minor evil updates, pay me later
# Tested on Kali 2025.4 XFCE
# Usage: sudo git clone https://github.com/aryanguenthner/365 /opt/365
# chmod -R 777 /home/kali/ /opt/365
# chmod a+x *.py *.sh /home/kali/ /opt/365
# Run it: sudo time ./kali-setup.sh | tee kali .log
################################################
echo

# TODO: Create a splash screen with menu options
# Menu options: 1 = Update Kali, 2 = Update Kali linux Headers, 3 Update VBox Guest Additions's, 4 Give me it all, update the kitchen sink!

# Keep the screen on during install.
xset s off            # Disable screensaver
xset s noblank        # No screen blanking
xset -dpms            # Disable DPMS power saving

# Kali Internet Optimizer, Attempt to make the download/upload speed faster
# Ensure /etc/sysctl.d/99-disable-ipv6.conf exists; create and apply it only if missing.
set -euo pipefail

# escalate to root if not already
if [ "${EUID:-$(id -u)}" -ne 0 ]; then
  exec sudo bash "$0" "$@"
fi

# Script to disable IPv6 on Debian-based systems
# Run with sudo/root privileges

set -e

CONF=/etc/sysctl.d/99-disable-ipv6.conf
echo "Checking IPv6 configuration..."
if [ -f "$CONF" ]; then
  echo "$CONF already exists, skipping creation..."
else
  echo "Creating $CONF..."
  cat >"$CONF" <<'EOF'
# Disable IPv6 (managed by installer)
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
EOF
  
  chmod 0644 "$CONF"
  echo "Configuration file created successfully"
  
  echo "Applying sysctl settings..."
  if sysctl -p "$CONF" >/dev/null 2>&1; then
    echo "IPv6 disabled successfully"
  else
    echo "Warning: Failed to apply settings immediately"
    echo "Settings will be applied on next boot"
  fi
fi

# Verify IPv6 status
echo ""
echo "Current IPv6 status:"
if [ "$(cat /proc/sys/net/ipv6/conf/all/disable_ipv6)" = "1" ]; then
  echo "✓ IPv6 is DISABLED"
else
  echo "✗ IPv6 is still ENABLED (reboot may be required)"
fi

echo ""
echo "Done!"
echo

# Kali Internet Speed Optimizer
bash /opt/365/kali-internet-optimizer.sh >/dev/null 2>&1 || true &

# Add kali to sudoers# Check if 'kali' is already in the sudoers file
if sudo grep -q "^kali ALL=(ALL) NOPASSWD:ALL" /etc/sudoers.d/kali 2>/dev/null; then
    echo "'kali' is already in sudoers. Skipping addition."
else
    echo "Adding 'kali' to sudoers..."
    echo
    echo "kali ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/kali > /dev/null
    echo "'kali' added to sudoers."
fi
echo

# Setting Variables
GREEN=032m
YELLOW=033m
RED=031m
BLUE=034m
PWD=$(pwd)

# Today's Date
timedatectl set-timezone America/Los_Angeles
timedatectl set-ntp true
echo -e "\e[034mToday is:\e[0m"
date | tee kali-setup-date.txt
sed -i '/LC_TIME/d' /etc/default/locale && echo 'LC_TIME=en_US.UTF-8' >> /etc/default/locale && locale-gen en_US.UTF-8 && update-locale && export LC_TIME=en_US.UTF-8

# Get the directory where the kali-setup.sh is executed
script_dir=$(pwd)

# Define output log file in the same directory
log_file="${script_dir}/kali.log"

# Redirect all stdout and stderr to the log file
exec > >(tee -a "$log_file") 2>&1

sudo mkdir -p /etc/X11/xinit/xinitrc.d
sudo bash -c 'cat <<EOF >/etc/X11/xinit/xinitrc.d/99-disable-blanking.sh
#!/bin/sh
xset s off
xset -dpms
xset s noblank
EOF'
sudo chmod +x /etc/X11/xinit/xinitrc.d/99-disable-blanking.sh


# Start your script here
echo "Running the kali-setup.sh script..."
sleep 2
echo
echo "Kali Script Running!"
echo
echo

echo -e "\e[034mGetting BIOS Info\e[0m"
sudo dmidecode -s bios-version | tee /home/kali/Desktop/bios-information.txt
echo
echo -e "\e[031mGetting Network Information\e[0m"
sudo apt-get update && apt-get -y install jq > /dev/null 2>&1
echo
# Network Information
# Get location details using ipinfo.io
# Fetch Public IP using multiple sources (fallback if one fails)
# Fetch Public IP with timeouts. 
# Added "|| echo Unavailable" to prevent script crash due to 'set -e' if offline.
EXT=$(curl -s --connect-timeout 5 https://api64.ipify.org || \
      curl -s --connect-timeout 5 https://ifconfig.me || \
      curl -s --connect-timeout 5 https://checkip.amazonaws.com || \
      echo "Unavailable")

# Get location details using ipinfo.io
LOCATION=$(curl -s --connect-timeout 5 ipinfo.io/json)
#LOCATION=$(curl -s ipinfo.io/json)
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

# Hackers like SSH
echo "Enabling SSH"
echo
sudo sed -i '40s/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config > /dev/null 2>&1
sudo systemctl enable ssh > /dev/null && sudo service ssh restart >/dev/null 2>&1
echo

echo "Fixing broken apt installs and removing conflicting ptunnel..."
sudo dpkg --configure -a
sudo apt-get -y --fix-broken install
sudo apt-get -y remove ptunnel || echo "ptunnel not found, skipping removal"

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
LOGFILE="/var/log/kali_apt_install_errors.log"
PACKAGES=(
golang-go netexec mono-devel printer-driver-escpr pipx python3-distutils-extra
torbrowser-launcher shellcheck yt-dlp libxcb-cursor0 libxcb-xtest0 docker.io
docker-compose freefilesync libfuse2t64 libkrb5-dev metagoofil pandoc
python3-docxtpl cmseek neo4j libu2f-udev freefilesync hcxdumptool hcxtools
assetfinder colorized-logs xfce4-weather-plugin npm ncat shotwell obfs4proxy
libc++1 sendmail ibus feroxbuster virtualenv mailutils mpack ndiff
python3-pyinstaller python3-notify2 python3-dev python3-pip python3-bottle
python3-cryptography python3-dbus python3-matplotlib python3-mysqldb
python3-openssl python3-pil python3-psycopg2 python3-pymongo python3-sqlalchemy
python3-tinydb python3-py2neo at bloodhound ipcalc nload crackmapexec hostapd
dnsmasq gedit cupp nautilus dsniff build-essential cifs-utils cmake curl ffmpeg
gimp git graphviz imagemagick libapache2-mod-php php-xml libmbim-utils
nfs-common openssl tesseract-ocr vlc xsltproc xutils-dev driftnet websploit
apt-transport-https openresolv screenfetch baobab speedtest-cli libffi-dev
libssl-dev libxml2-dev libxslt1-dev zlib1g-dev awscli sublist3r w3m cups
system-config-printer gobuster libreoffice gcc
)

echo "Starting installs..."
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

echo
echo "Done! Check $LOGFILE for anything that failed."
echo

sudo apt-get autoremove -y && updatedb

# Setting Variables
GREEN=032m
YELLOW=033m
RED=031m
BLUE=034m
PWD=$(pwd)
export LC_TIME="en_US.UTF-8"

# Change directory to Kali Downloads
DOWNLOADS="/home/kali/Downloads"
cd $DOWNLOADS || exit 1
echo "Switched to $DOWNLOADS"

check_install() {
    local cmd="$1"
    if command -v "$cmd" &>/dev/null; then
        echo -e "\033[1;32m[✓] $cmd installed successfully\033[0m"
    else
        echo -e "\033[1;31m[✗] Failed to install $cmd\033[0m"
        exit 1
    fi
}


# === Google Chrome Install ===
if command -v google-chrome-stable &>/dev/null; then
    echo -e "\033[1;32m[✓] Found Google Chrome\033[0m"
    echo
else
    echo "Installing Google Chrome Web Browser..."
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
echo "[*] Checking if Slack is installed..."

# Check if Slack exists
if ! command -v slack &> /dev/null; then
    echo "[!] Slack not found. Installing Slack Desktop..."

    SLACK_DEB="slack-desktop.deb"
    wget -O "$SLACK_DEB" "https://downloads.slack-edge.com/releases/linux/4.33.90/prod/x64/slack-desktop-4.33.90-amd64.deb"

    sudo dpkg -i "$SLACK_DEB" || sudo apt --fix-broken install -y

    rm "$SLACK_DEB"

    echo "[+] Slack installed."
else
    echo "[*] Slack is already installed."
fi
echo

# --- Configuration ---
WKHTMLTOX_DEB_URL="https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-3/wkhtmltox_0.12.6.1-3.bookworm_amd64.deb"
WKHTMLTOX_DEB_FILE="wkhtmltox_0.12.6.1-3.bookworm_amd64.deb"
NRICH_DEB_URL="https://gitlab.com/api/v4/projects/33695681/packages/generic/nrich/latest/nrich_latest_x86_64.deb"
NRICH_DEB_FILE="nrich_latest_x86_64.deb"

# --- 1. WKHTMLTOX Logic ---
# Check if wkhtmltopdf binary exists
if command -v wkhtmltopdf &> /dev/null; then
    echo "[INFO] wkhtmltox is already installed. Skipping."
else
    echo "[INFO] wkhtmltox not found. Downloading..."
    wget --no-check-certificate -O "$WKHTMLTOX_DEB_FILE" "$WKHTMLTOX_DEB_URL"
    
    echo "[INFO] Installing wkhtmltox..."
    sudo dpkg -i "$WKHTMLTOX_DEB_FILE"
    
    # Run install -f to fix missing dependencies (common with wkhtmltox)
    sudo apt-get install -f -y
    
    # Cleanup
    rm "$WKHTMLTOX_DEB_FILE"
fi

echo "------------------------------------------------"

# --- 2. Shodan Nrich Logic ---
# Check if nrich binary exists
if command -v nrich &> /dev/null; then
    echo "[INFO] Shodan Nrich is already installed. Skipping."
else
    echo "[INFO] Shodan Nrich not found. Downloading..."
    wget --no-check-certificate -O "$NRICH_DEB_FILE" "$NRICH_DEB_URL"
    
    echo "[INFO] Installing Shodan Nrich..."
    sudo dpkg -i "$NRICH_DEB_FILE"
    
    # Cleanup
    rm "$NRICH_DEB_FILE"
fi

echo
echo "[SUCCESS] Checks complete."
echo

# Define the target path
COMPOSE_PLUGIN="$HOME/.docker/cli-plugins/docker-compose"

# Check if the file exists
if [ -f "$COMPOSE_PLUGIN" ]; then
    echo "[INFO] Docker Compose plugin already exists at $COMPOSE_PLUGIN. Skipping."
else
    echo "[INFO] Docker Compose plugin not found. Installing..."
    
    # Create the docker plugins directory
    mkdir -p ~/.docker/cli-plugins
    
    # Download the CLI into the plugins directory
    # Note: v2.0.1 is hardcoded here per your snippet
    curl -sSL https://github.com/docker/compose/releases/download/v2.0.1/docker-compose-linux-x86_64 -o "$COMPOSE_PLUGIN"
    
    # Make the CLI executable
    chmod +x "$COMPOSE_PLUGIN"
    
    echo "[SUCCESS] Docker Compose plugin installed."
    echo
fi
echo

# Updog Install
# Create a virtual environment
DOG=/root/.local/share/pipx/venvs/updog/bin/updog
if [ -f "$DOG" ]
then
    echo -e "\e[031mFound The Dog\e[0m"
else
    echo -e "\e[031mGetting the Dog\e[0m"
sudo pipx install updog
sudo pipx ensurepath
export PATH=/root/.local/bin:$PATH
echo 'export PATH=/root/.local/bin:$PATH' >> ~/.zshrc
source ~/.zshrc
    echo
fi
echo

# 1. Keep Nmap scans Organized
# -----------------------------------
sudo mkdir -p /home/kali/Desktop/testing/nmapscans/
echo '[+] Scan directory created.'

# 2. Define Variables
# -----------------------------------
NMAP_LUA="/usr/share/nmap/nselib/http.lua"
NEW_UA='Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36'

# 3. Upgrade Nmap User Agent
# -----------------------------------
echo 'Checking Nmap User Agent status...'

if grep -Fq "Chrome/119.0.0.0" "$NMAP_LUA"; then
    echo '[-] User Agent is already upgraded. Skipping modification.'
else
    echo '[!] Standard User Agent detected. Upgrading...'
    
    echo '--- Before ---'
    sed -n '160p' "$NMAP_LUA"
    echo
    # We use double quotes here to allow the $NEW_UA variable to expand
    sudo sed -i "160c\\local USER_AGENT = stdnse.get_script_args('http.useragent') or \"$NEW_UA\"" "$NMAP_LUA"
    echo
    echo '--- After ---'
    sed -n '160p' "$NMAP_LUA"
    echo '[+] Upgrade Complete: Nmap is now Great Again.'
fi
echo

# ==========================================
# Organize and Upgrade Nmap
# ==========================================

# 1. Create Directory
sudo mkdir -p /home/kali/Desktop/testing/nmapscans/
echo '[+] Scan directory created.'

# 2. Define Nmap Variables
NMAP_LUA="/usr/share/nmap/nselib/http.lua"
NEW_UA='Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36'

# 3. Upgrade Logic
echo 'Checking Nmap User Agent status...'

if grep -Fq "Chrome/119.0.0.0" "$NMAP_LUA"; then
    echo '[-] User Agent is already upgraded. Skipping modification.'
else
    echo '[!] Standard User Agent detected. Upgrading...'
    
    echo '--- Before ---'
    sed -n '160p' "$NMAP_LUA"

    # sudo sed command
    sudo sed -i "160c\\local USER_AGENT = stdnse.get_script_args('http.useragent') or \"$NEW_UA\"" "$NMAP_LUA"
    
    echo '--- After ---'
    sed -n '160p' "$NMAP_LUA"
    echo '[+] Upgrade Complete: Nmap is now Great Again.'
fi

echo # Empty line for spacing

# ==========================================
# Nmap Bootstrap File Checker
# ==========================================

# 1. Define Bootstrap Variables
# Note: We point FILE to the same place we download it to avoid loops
SCAN_DIR="/home/kali/Desktop/testing/nmapscans"
XSL_FILE="$SCAN_DIR/nmap-bootstrap.xsl"
XSL_URL="https://raw.githubusercontent.com/aryanguenthner/nmap-bootstrap-xsl/stable/nmap-bootstrap.xsl"

# 2. Download Logic
if [ -f "$XSL_FILE" ]; then
    echo '[+] Found nmap-bootstrap.xsl'
else
    # printf is safer than echo -e for colors across different shells
    # \033[34m = Blue, \033[0m = Reset
    printf '\033[34m[!] Fetching Missing Bootstrap File...\033[0m\n'
    
    wget --no-check-certificate -q -O "$XSL_FILE" "$XSL_URL"

    if [ -f "$XSL_FILE" ]; then
        echo '[+] Download successful.'
    else
        printf '\033[31m[!] Download failed. Check internet connection.\033[0m\n'
    fi
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

# 1. Configure Current Session (So script works immediately)
echo 'Configuring Go environment...'
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# 2. Persist to ZSHRC (Only if not already there)
# We check if the line exists using grep before appending
RC_FILE="$HOME/.zshrc"

if ! grep -q "export PATH=\$PATH:/usr/local/go/bin" "$RC_FILE"; then
    echo 'export PATH=$PATH:/usr/local/go/bin' >> "$RC_FILE"
fi

if ! grep -q "export GOPATH=\$HOME/go" "$RC_FILE"; then
    echo 'export GOPATH=$HOME/go' >> "$RC_FILE"
fi

# 3. Check and Install Go
if command -v go >/dev/null 2>&1; then
    echo -e "\e[33m[SKIP]\e[0m Go is already installed."
else
    # Blue text using printf
    printf '\033[34m[!] Go is missing. Downloading and Installing Go 1.23.0...\033[0m\n'
    
    # Download to /tmp to keep folder clean
    wget --no-check-certificate -q -O /tmp/go1.23.0.linux-amd64.tar.gz https://go.dev/dl/go1.23.0.linux-amd64.tar.gz
    
    # Remove old Go installation to prevent conflicts
    if [ -d "/usr/local/go" ]; then
        echo "[-] Cleaning up old /usr/local/go directory..."
        sudo rm -rf /usr/local/go
    fi

    # Extract
    sudo tar -xzf /tmp/go1.23.0.linux-amd64.tar.gz -C /usr/local
    
    # Cleanup downloaded file
    rm /tmp/go1.23.0.linux-amd64.tar.gz
    
    echo -e "\e[32m[+] Go installation complete.\e[0m"
fi
echo

# Green text using printf (Single quotes prevent ! history expansion error)
printf '\033[32m[+] Go environment variables updated for all shells!\033[0m\n'
echo
# IP Address - Ensure it's added to all shell configs
echo "Ensuring 'hostname -I' is in all shell configs..."

# --- Shellz Hellz ---
SHELL_CONFIGS=("$HOME/.zshrc" "$HOME/.bashrc")
# --------------------------

for FILE in "${SHELL_CONFIGS[@]}"; do
    if [[ -f "$FILE" ]] && ! grep -q "hostname -I" "$FILE"; then
        echo -e "\e[32mAdding 'hostname -I' to $FILE...\e[0m"
        echo 'hostname -I' | sudo tee -a "$FILE" > /dev/null
    else
        echo -e "\e[33m'hostname -I' already exists in $FILE. Skipping...\e[0m"
    fi
done
echo

# Ensure /opt exists before navigating
if [[ ! -d "/opt" ]]; then
    echo -e "\e[31mDirectory /opt does not exist. Creating it now...\e[0m"
    sudo mkdir -p /opt
fi

cd /opt || { echo -e "\e[31mFailed to change directory to /opt. Exiting...\e[0m"; exit 1; }

# Function to check if a Go tool is installed and install it if missing
check_and_install() {
    local tool_name=$1
    local go_path="$HOME/go/bin/$tool_name"

    if [[ -f "$go_path" ]]; then
        echo -e "\e[32m$tool_name is already installed. Skipping...\e[0m"
    else
        echo -e "\e[33mInstalling $tool_name...\e[0m"
        go install -v "$2"
    fi
    echo
}

# 1. Ensure Go is in the path for this script execution
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

# 2. Define the "Check and Install" Function
check_and_install() {
    local TOOL_NAME="$1"
    local INSTALL_URL="$2"

    # Check if tool exists in PATH or GOPATH
    if command -v "$TOOL_NAME" >/dev/null 2>&1 || [ -f "$GOPATH/bin/$TOOL_NAME" ]; then
        echo "[-] $TOOL_NAME is already installed. Skipping."
    else
        # FIX: We use single quotes for the text format to protect [!] from Zsh
        # We use %s to safely insert the $TOOL_NAME variable
        printf '\033[34m[!] Installing %s...\033[0m\n' "$TOOL_NAME"
        
        # Run the install
        go install "$INSTALL_URL"

        # Verify if it worked
        if [ -f "$GOPATH/bin/$TOOL_NAME" ]; then
             echo "[+] $TOOL_NAME installed successfully."
        else
             printf '\033[31m[!] Failed to install %s. Check network/Go version.\033[0m\n' "$TOOL_NAME"
        fi
    fi
}

echo "Starting Tool Checks..."
echo

# 3. Run the Checks
# -------------------------------------------
check_and_install "nuclei"   "github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest"
check_and_install "httpx"    "github.com/projectdiscovery/httpx/cmd/httpx@latest"
check_and_install "katana"   "github.com/projectdiscovery/katana/cmd/katana@latest"
check_and_install "uncover"  "github.com/projectdiscovery/uncover/cmd/uncover@latest"
check_and_install "gospider" "github.com/jaeles-project/gospider@latest"
check_and_install "gobuster" "github.com/OJ/gobuster/v3@latest"

echo
echo "[+] Cyber Tools check complete."
echo

# https://github.com/blacklanternsecurity/bbot
# Install this one its awesome

echo '--- Configuring CeWL Password Lists ---'

# 1. Define Variables
CEWL_DIR="/opt/cewl"
REPO_URL="https://github.com/digininja/CeWL.git"

# 2. Check if CeWL Directory Exists
if [ -d "$CEWL_DIR" ]; then
    echo '[-] CeWL repository already exists in /opt. Skipping clone.'
else
    # Single quotes here prevent the error
    printf '\033[34m[!] Cloning CeWL repository...\033[0m\n'
    sudo git clone "$REPO_URL" "$CEWL_DIR"
fi

# 3. Check and Install Ruby Gems
GEMS=("mime-types" "mini_exiftool" "rubyzip" "spider")

echo 'Checking Ruby dependencies...'

for gem_name in "${GEMS[@]}"; do
    if gem list -i "^${gem_name}$" > /dev/null 2>&1; then
        echo "[-] Gem '$gem_name' is already installed."
    else
        # FIX: Single quotes around the format string '[!] ...'
        printf '\033[34m[!] Installing missing gem: %s...\033[0m\n' "$gem_name"
        sudo gem install "$gem_name"
    fi
done

echo
echo '[+] CeWL setup complete.'


# --- ZSH/BASH COMPATIBILITY FIX ---
# This line disables "History Expansion" so using "!" doesn't crash the script
set +H 2>/dev/null || setopt no_banghist 2>/dev/null

echo '--- Configuring Hacking APIs (Postman) ---'

# 1. Define Variables
POSTMAN_DIR="/opt/Postman"
POSTMAN_BIN="/usr/bin/postman"
DOWNLOAD_URL="https://dl.pstmn.io/download/latest/linux64"
TEMP_FILE="/tmp/postman-linux-x64.tar.gz"

# 2. Check if Postman Directory Exists
if [ -d "$POSTMAN_DIR" ]; then
    echo "[-] Postman is already installed in /opt. Skipping download."
else
    # Single quotes ensure Zsh doesn't try to interpret [!]
    printf '\033[34m[!] Downloading Postman...\033[0m\n'
    
    # Download to /tmp to keep your current folder clean
    # -q = quiet, --show-progress = shows a nice bar
    wget -q --show-progress -O "$TEMP_FILE" "$DOWNLOAD_URL"
    
    printf '\033[34m[!] Extracting to /opt...\033[0m\n'
    sudo tar -xzf "$TEMP_FILE" -C /opt
    
    # Clean up the downloaded file
    rm "$TEMP_FILE"
    echo "[+] Extraction complete."
fi

# 3. Check and Create Symlink
# We check if the 'postman' command is already linked
if [ -L "$POSTMAN_BIN" ] || [ -f "$POSTMAN_BIN" ]; then
    echo "[-] Postman symlink already exists."
else
    printf '\033[34m[!] Creating /usr/bin/postman symlink...\033[0m\n'
    sudo ln -s /opt/Postman/Postman "$POSTMAN_BIN"
    echo "[+] Symlink created."
fi
echo


# Verify gowitness 3.0.5 is in /opt/365
GOWIT=/opt/365/gowitness
if [ -f "$GOWIT" ]
then
    echo -e "\033[1;32m[✓] Found GoWitness 3.0.5\033[0m"
else
    echo -e "\e[031mDownloading Missing GoWitness 3.0.5\e[0m"
    chmod -R 777 /opt/365
    wget --no-check-certificate -O /opt/365/gowitness 'https://drive.google.com/uc?export=download&id=1C-FpaGQA288dM5y40X1tpiNiN8EyNJKS' # gowitness 3.0.5
fi
echo

# === Function to clone repos safely ===
clone_if_missing() {
    local repo_url="$1"
    local folder_name="$2"

    if [ -d "$folder_name" ]; then
        echo "[SKIP] $folder_name already exists."
    else
        echo "[CLONE] $repo_url → $folder_name"
        git clone "$repo_url" "$folder_name" || echo "[ERROR] Failed to clone $folder_name"
    fi

    echo
}

# === Ask user if they want to install extra Git repositories ===
cd /opt || { echo "Failed to enter /opt"; exit 1; }

echo
echo "Would you like to install extra Git repositories? (yes/no)"
echo "(Defaults to NO after 30 seconds)"
echo -n "> "

# Initialize response variable
response=""

# Handle interactive and non-interactive sessions
if [ -t 0 ]; then
    # Interactive mode - use timeout
    if timeout 30 read -r response; then
        # Got input, proceed
        true
    else
        # Timeout occurred, use default
        response="no"
        echo "(timeout - defaulting to NO)"
    fi
else
    # Non-interactive mode - skip entirely
    response="no"
    echo "(non-interactive mode - defaulting to NO)"
fi

# Normalize response (convert to lowercase using tr)
response=$(echo "$response" | tr '[:upper:]' '[:lower:]' | xargs)
response=${response:-no}   # default to no if empty

echo

if [[ "$response" == "yes" || "$response" == "y" ]]; then
    echo "Proceeding with extra installations..."
    echo "This is going to take a minute – hold my root beer."
    echo

    # Define the function INSIDE the block so it's ready to use
    clone_if_missing() {
        local repo_url="$1"
        local folder_name="$2"

        # If no folder name provided, extract it from URL
        if [ -z "$folder_name" ]; then
            folder_name=$(basename "$repo_url" .git)
        fi

        if [ -d "$folder_name" ]; then
            echo -e "\e[33m[SKIP]\e[0m $folder_name already exists."
        else
            echo -e "\e[32m[CLONE]\e[0m $folder_name..."
            git clone "$repo_url" "$folder_name" || echo "[ERROR] Failed to clone $folder_name"
        fi
    }

    # --- Tool Installations ---

    echo "--- Installing Git Repos ---"
    clone_if_missing "https://github.com/Wh04m1001/DFSCoerce" "DFSCoerce"
    clone_if_missing "https://github.com/infosecn1nja/MaliciousMacroMSBuild.git" "MaliciousMacroMSBuild"
    clone_if_missing "https://github.com/TheRook/subbrute.git" "subbrute"
    clone_if_missing "https://github.com/aryanguenthner/BridgeKeeper.git" "BridgeKeeper"
    clone_if_missing "https://github.com/sense-of-security/ADRecon.git" "ADRecon"
    clone_if_missing "https://github.com/cddmp/enum4linux-ng.git" "enum4linux-ng"
    clone_if_missing "https://github.com/danielmiessler/SecLists.git" "SecLists"
    clone_if_missing "https://github.com/meirwah/awesome-incident-response.git" "awesome-incident-response"
    clone_if_missing "https://github.com/fuzzdb-project/fuzzdb.git" "fuzzdb"
    clone_if_missing "https://github.com/swisskyrepo/PayloadsAllTheThings.git" "PayloadsAllTheThings"
    clone_if_missing "https://github.com/s0md3v/AwesomeXSS.git" "AwesomeXSS"
    clone_if_missing "https://github.com/payloadbox/xss-payload-list.git" "xss-payload-list"
    clone_if_missing "https://github.com/foospidy/payloads.git" "payloads-foospidy"
    clone_if_missing "https://github.com/joaomatosf/jexboss.git" "jexboss"
    clone_if_missing "https://github.com/laramies/theHarvester.git" "theHarvester"
    clone_if_missing "https://github.com/OWASP/CheatSheetSeries.git" "OWASP-CheatSheet"
    clone_if_missing "https://github.com/projectzeroindia/CVE-2019-11510.git" "Pulse-Exploit"
    clone_if_missing "https://github.com/dxa4481/truffleHog.git" "truffleHog"
    clone_if_missing "https://github.com/awslabs/git-secrets.git" "git-secrets"
    clone_if_missing "https://github.com/zricethezav/gitleaks.git" "gitleaks"
    clone_if_missing "https://github.com/s0md3v/Breacher.git" "Breacher"
    clone_if_missing "https://github.com/sundowndev/PhoneInfoga.git" "PhoneInfoga" 
    clone_if_missing "https://github.com/bitsadmin/wesng.git" "wesng"
    clone_if_missing "https://github.com/byt3bl33d3r/SprayingToolkit.git" "SprayingToolkit"

    echo
    echo "Extra Tools Installed Successfully."

else
    # This runs if user types anything other than yes/y or on timeout
    echo -e "\e[33mSkipping Kali extra repos. Continuing...\e[0m"
fi
echo


# Nmap works dont forget --> nmap -iL smb-ips.txt --stats-every=1m -Pn -p 445 -script smb-brute --script-args='smbpassword=Summer2023,userdb=usernames.txt,smbdomain=xxx.com,smblockout=true' -oA nmap-smb-brute-2023-07-19'
# Hydra works dont forget --> hydra -p Summer2019 -l Administrator smb://192.168.1.23
# Metasploit works dont forget --> 
# set smbpass Summer2019
# set smbuser Administrator
# set rhosts 192.168.1.251
# run


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

# === Docker Configuration ===
echo "Configuring Docker..."

# 1. Stop Docker Service AND Socket
# We check if either is active to avoid unnecessary errors
if systemctl is-active --quiet docker || systemctl is-active --quiet docker.socket; then
    echo "Stopping Docker service and socket..."
    # The socket must be stopped, or it will trigger the service again
    sudo systemctl stop docker.socket docker.service
else
    echo "Docker is not currently running."
fi

# 2. Disable Docker on boot
# We disable the socket too, otherwise it will wake up Docker when called
echo "Disabling Docker startup..."
sudo systemctl disable docker.socket docker.service > /dev/null 2>&1

# 3. Safely remove docker0 interface
# Check if the interface exists before trying to delete it to avoid "Cannot find device" errors
if ip link show docker0 > /dev/null 2>&1; then
    echo "Removing docker0 network interface..."
    sudo ip link delete docker0
else
    echo "docker0 interface not found. Skipping removal."
fi
echo

echo "Checking if you need VirtualBox installed"
echo

# Detect if running on VirtualBox or a physical machine
VBOX=$(sudo dmidecode -s system-manufacturer 2>/dev/null)
VBOX1=$(sudo dmidecode -s bios-version 2>/dev/null)

if [[ "$VBOX1" == "VirtualBox" ]]; then
    echo "Running inside VirtualBox. Skipping installation."
    echo
else
    echo "Running on a physical machine. Proceeding with installation."
    echo

    # Add Oracle VirtualBox GPG key
    echo "Adding Oracle VirtualBox GPG key..."
    wget -qO- https://www.virtualbox.org/download/oracle_vbox_2016.asc \
        | sudo tee /etc/apt/trusted.gpg.d/oracle_vbox_2016.asc > /dev/null

    # Install prerequisites
    echo "Installing required libvpx7 package..."
    wget -q http://ftp.us.debian.org/debian/pool/main/libv/libvpx/libvpx7_1.12.0-1+deb12u3_amd64.deb
    sudo dpkg -i libvpx7_1.12.0-1+deb12u3_amd64.deb || sudo apt --fix-broken install -y

    # Install VirtualBox
    echo "Installing VirtualBox..."
    sudo apt update
    sudo apt install -y \
        virtualbox \
        virtualbox-dkms \
        virtualbox-ext-pack \
        virtualbox-qt \
        virtualbox-guest-utils \
        virtualbox-guest-x11 \
        linux-headers-$(uname -r)

    # Add user to vboxusers group
    echo "Adding user to vboxusers group..."
    sudo usermod -aG vboxusers "$USER"

    echo "VirtualBox installation completed."
    echo
fi


# Insurance
# sudo modprobe vboxnetflt
# Cross your fingers
# Enable Kali Autologin

echo "Hack The Planet"
echo
# Get ready for Ai Integrations

# --- Part 1: Install Claude Desktop (Latest Version) ---

# 1. Fetch the latest release URL dynamically from GitHub
echo "Fetching latest version info..."
DOWNLOAD_URL=$(curl -s https://api.github.com/repos/aaddrick/claude-desktop-debian/releases/latest \
| grep -o 'https://[^"]*amd64.deb' \
| head -n 1)

DEB_FILE="/tmp/claude-desktop.deb"

if [ -z "$DOWNLOAD_URL" ]; then
    echo "Error: Could not retrieve latest download URL."
    exit 1
fi

echo "Latest version found: $(basename "$DOWNLOAD_URL")"

# 2. Check if claude-desktop is installed
if ! dpkg -s claude-desktop >/dev/null 2>&1; then
    echo "Claude Desktop is NOT installed. Initiating download..."
    echo
    
    # Download the file
    wget -O "$DEB_FILE" "$DOWNLOAD_URL"
    
    if [ $? -eq 0 ]; then
        echo "Download complete. Installing..."
        echo
        # Install with sudo
        sudo dpkg -i "$DEB_FILE"
        
        # Fix any missing dependencies just in case
        sudo apt-get install -f -y
        
        echo "Claude Desktop installation complete."
        echo
        rm "$DEB_FILE"
    else
        echo "Error: Failed to download Claude Desktop."
        echo
        exit 1
    fi
else
    echo "Claude Desktop is already installed. Skipping installation."
    echo
fi
echo

# --- Part 2: Configure MCP ---

# Define the target file path
CONFIG_FILE="$HOME/.config/Claude/claude_desktop_config.json"

# Logic: Check if file exists, create path if not
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Configuration file not found. Creating directory and file..."
    # install -D creates the target directory automatically if missing
    install -D /dev/null "$CONFIG_FILE"
else 
    echo "Configuration file already exists. Overwriting with new config..."
fi

# Write the JSON content to the file
cat << 'EOF' > "$CONFIG_FILE"
{
    "mcpServers": {
        "kali_mcp": {
            "command": "python3",
            "args": [
                "/opt/MCP-Kali-Server/mcp_server.py",
                "--server",
                "http://localhost:5000/"
            ]
        }
    }
}
EOF

# Verify the output
echo "--------------------------------"
echo "Current Configuration:"
cat "$CONFIG_FILE"
echo

echo "Enabling Autologin..."
# Use sed to replace the value regardless of whether it's commented or not
sudo sed -i 's/^#*autologin-user=.*/autologin-user=kali/' /etc/lightdm/lightdm.conf
sudo sed -i 's/^#*autologin-user-timeout=.*/autologin-user-timeout=0/' /etc/lightdm/lightdm.conf

# Create the autologin group if it doesn't exist and add kali
sudo groupadd -r autologin 2> /dev/null
sudo gpasswd -a kali autologin

echo "Autologin configured successfully"
echo

echo -e "\nexport LC_ALL=en_US.UTF-8\nexport LANG=en_US.UTF-8" >> ~/.zshrc
source ~/.zshrc

# Kali Setup Finish Time
date | tee kali-setup-finish-date.txt
echo
echo "Buy me a coffee"
reboot
# Just in case DNS issues: nano -c /etc/resolvconf/resolv.conf.d/head
# Gucci Mang
# Pay me later
# https://sites.google.com/site/gdocs2direct/
# Printer Hacks
# sudo usermod -aG lpadmin kali      
# sudo /etc/init.d/cups restart
