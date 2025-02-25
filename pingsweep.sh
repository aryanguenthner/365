#!/usr/bin/env bash
#######################################################
# Enumerate open ports and services
# Added feature to scan using TOR
# Hosts that responded to ICMP are output to targets.txt 
# Learn More @ https://github.com/aryanguenthner/
# Tested on Kali 2024.2
# Last minor updated 02/24/2025
# The future is now
# Edit this script to fit your system
# Got Nmap?
######################################################
# MOBILE=TODO enable mobile alerts to be sent when scan is completed
echo -e "\e[031mHack The Planet\e[0m"
# Setting Variables
BLUE=034m
CITY=$(curl -s http://ip-api.com/line?fields=timezone | cut -d "/" -f 2)
SUBNET=$(ip r | awk 'FNR == 2 {print $1}')
TARGETS=targets.txt
FILE0=$(date +%Y%m%d).nmap-pingsweep_$RANDOM
FILE1=$(date +%Y%m%d).nmapscan_$RANDOM
BOOTSTRAP=nmap-bootstrap.xsl
NV=$(nmap -V | awk 'FNR == 1 {print $1,$2,$3}')
RANDOM=$$
PWD=$(pwd)
#SCRIPTS=""
SYNTAX="nmap --exclude $KALI -T4 -Pn -sV -sC -p- --open -vvvv --stats-every=1m --max-retries=0 --min-hostgroup=100 --min-parallelism=100 $SUBNET -oA $PWD/$FILE1"
export LC_TIME="en_US.UTF-8"
DATE=date
echo
# Network Information
EXT=$(curl -s https://api64.ipify.org || curl -s https://ifconfig.me || curl -s https://checkip.amazonaws.com)
EXT=${EXT:-"DarkWeb"}
LOCATION=$(curl -s ipinfo.io/json)

# Validate JSON Response
if ! echo "$LOCATION" | jq empty 2>/dev/null; then
    LOCATION='{"country":"DarkWeb","region":"DarkWeb","city":"DarkWeb"}'
fi

COUNTRY=$(echo "$LOCATION" | jq -r '.country')
REGION=$(echo "$LOCATION" | jq -r '.region')
CITY=$(echo "$LOCATION" | jq -r '.city')
KALI=$(hostname -I | awk '{print $1}')
SUBNET=$(ip r | awk 'FNR == 2 {print $1}')

echo "---------------------------------"
printf "| %-12s | %-20s |\n" "Label" "Value"
echo "---------------------------------"
printf "| %-12s | %-20s |\n" "Public IP" "$EXT"
printf "| %-12s | %-20s |\n" "Country" "$COUNTRY"
printf "| %-12s | %-20s |\n" "State" "$REGION"
printf "| %-12s | %-20s |\n" "City" "$CITY"
printf "| %-12s | %-20s |\n" "Kali IP" "$KALI"
printf "| %-12s | %-20s |\n" "Kali Subnet" "$SUBNET"
echo "---------------------------------"
echo

# Dependency Check
echo -e "\e[034mRunning Dependency check\e[0m"
echo
# Check if TOR is installed
echo "Checking Dark Web Requirements..."
sudo apt-get install -y tor torbrowser-launcher python3-stem jq > /dev/null 2>&1
# Verify if TorGhostNG is installed
TORNG=/usr/bin/torghostng
if [ -f "$TORNG" ]; then
    echo -e "\e[031mFound TorghostNG\e[0m"
else
    echo "TorghostNG not found, installing..."
    sudo git clone https://github.com/aryanguenthner/torghostng /opt/torghostng
    cd /opt/torghostng || exit
    sudo touch /etc/sysctl.conf
    sudo python3 install.py
    echo "TorghostNG is installed"
fi
# Check for GoWitness
GOWIT=$PWD/gowitness
if [ -f "$GOWIT" ]; then
    echo -e "\e[031mFound GoWitness 3.0.5\e[0m"
else
    echo -e "\e[031mCopying /opt/365/gowitness to $PWD\e[0m"
    cp /opt/365/gowitness "$PWD"
    chmod a+x $PWD/gowitness
    chmod -R 777 "$PWD"
fi
# Check for pingsweep.sh
pingsweep=pingsweep.sh
if [ -f "$pingsweep" ]; then
    echo -e "\e[031mFound pingsweep.sh\e[0m"
else
    echo -e "\e[034mGetting pingsweep.sh from /opt/365\e[0m"
    cp /opt/365/pingsweep.sh "$PWD"
fi
# Check for nmap-bootstrap
NB=nmap-bootstrap.xsl
if [ -f "$NB" ]; then
    echo -e "\e[031mFound nmap-bootstrap.xsl\e[0m"
else
    echo -e "\e[034mCopying Missing $BOOTSTRAP File\e[0m"
    cp /opt/365/nmap-bootstrap.xsl /home/kali/Desktop/testing/nmapscans/
fi
# Simulated Progress Bar
echo -ne '#####                     (33%)\r'
sleep 1
echo -ne '#############             (66%)\r'
sleep 1
echo -ne '#######################   (100%)\r'
echo -ne '\n'

# User Dark Web Input
echo "Scan using TOR?"
echo
echo "1) Yes"
echo "2) No"
echo
read -p "Enter your choice (1 or 2): " TORCHOICE
echo

if [[ "$TORCHOICE" =~ ^(1|[Yy])$ ]]; then
    # Start Tor Service
    echo "Starting Tor service..."
    sudo systemctl start tor
    echo

    # Connect via TorGhostNG (Netherlands)
    echo -e "\033[1;32m[✔] Using TorGhostNG to connect to the Dark Web...\033[0m"
    sudo torghostng -id nl
    echo
    echo -e "\e[031mEstablishing a Connection to the Dark Web\e[0m"

    # Simulated Progress Bar
    echo -ne '#####                     (33%)\r'
    sleep 1
    echo -ne '#############             (66%)\r'
    sleep 1
    echo -ne '#######################   (100%)\r'
    echo -ne '\n'

    echo -e "\e[31mConnection Established. You can now Scan and access .onion sites.\e[0m"
    sleep 2

elif [[ "$TORCHOICE" =~ ^(2|[Nn])$ ]]; then
    # Check if Tor is already running
    if pgrep -x "tor" > /dev/null; then
echo -e "\033[1;33m[!] Warning: Tor is already running!\033[0m"
printf "| %-12s | %-20s |\n" "Public IP" "$EXT"
printf "| %-12s | %-20s |\n" "Country" "$COUNTRY"
printf "| %-12s | %-20s |\n" "State" "$REGION"
printf "| %-12s | %-20s |\n" "City" "$CITY"
echo -e "\033[1;33m[!] If you intended to disconnect: torghost -x\033[0m"
    fi
else
    echo "Invalid choice. Try Harder."
    exit 1
fi
echo

# User Input
echo "Choose Nmap Input file or Subnet?"
echo
echo "1) Input File"
echo "2) Target: IP, Subnet or Domain"
echo
read -p "Enter your choice (1 or 2): " NMAPCHOICE
echo

if [[ "$NMAPCHOICE" == "1" ]]; then
    read -p "Path to nmap input file: " INPUTFILE
    echo -e "\nNmap Input File: $INPUTFILE"
sleep 2

elif [[ "$NMAPCHOICE" == "2" ]]; then
    read -p "Scan Detected Subnet ($SUBNET)? [y/n]: " CONFIRM_SUBNET
    if [[ "$CONFIRM_SUBNET" =~ ^[Yy]$ ]]; then
        echo -e "\nUsing detected subnet: $SUBNET"
    else
        read -p "Enter Target: IP, Subnet or Domain: " SUBNET
        echo -e "\nNmap Scanning Set to: $SUBNET"
    fi
sleep 2
else
    echo "Invalid choice. Try Harder."
    exit 1
fi
echo

# Nmap Scan Enumeration
# Ensure Output Directory Exists (Organized by Date)
DATE=$(date +"%Y-%m-%d")
OUTPUT_DIR="$PWD/$DATE"
mkdir -p "$OUTPUT_DIR"
chmod -R 777 "$OUTPUT_DIR"

echo -e "\033[1;32m[✔] Nmap Output: $OUTPUT_DIR/$FILE1\033[0m"
sleep 1
echo
# Ping Sweep
nmap $SUBNET -vvvv --stats-every=1m -sn -n --exclude $KALI -oG $OUTPUT_DIR/$FILE0 && cat $OUTPUT_DIR/$FILE0 | grep --color=always "hosts up"
echo
echo -e "\e[034mPing Sweep Completed\e[0m"
echo -e "\e[034mPing Sweep Target List File -> targets.txt\e[0m"
cat $OUTPUT_DIR/$FILE0 | grep "Up" | awk '{print $2}' 2>&1 | tee $OUTPUT_DIR/targets.txt
# Run Nmap Enumeration
if [[ -n "$SUBNET" ]]; then
    echo -e "\n\033[1;36m[*] Scanning: $SUBNET\033[0m"
    echo
    nmap --exclude "$KALI" -T4 -Pn -sV -sC -p- --open -vvvv --stats-every=1m --max-retries=0 --min-hostgroup=100 --min-parallelism=100 "$SUBNET" -oA "$OUTPUT_DIR/$FILE1"
    echo
    echo -e "\n\033[1;32m[✔] Nmap scan completed: $SUBNET\033[0m"

elif [[ -n "$INPUTFILE" && -f "$INPUTFILE" ]]; then
    echo -e "\n\033[1;36m[*] Scanning from Input File: $INPUTFILE\033[0m"
    nmap --exclude "$KALI" -T4 -Pn -sV -sC -p- --open -vvvv --stats-every=1m --max-retries=0 --min-hostgroup=100 --min-parallelism=100 -iL "$INPUTFILE" -oA "$OUTPUT_DIR/$FILE1"
    echo
    echo -e "\n\033[1;32m[✔] Nmap scan completed on Input File: $INPUTFILE\033[0m"
else
    echo -e "\n\033[1;31m[✘] Invalid choice or missing input file. Try Harder.\033[0m"
    exit 1
fi
echo -e "\n\033[1;32m[✔] Scan results saved to: $OUTPUT_DIR/$FILE1\033[0m\n"

# Bonus Feature
echo -e "\e[034mMetasploit\e[0m"
echo "service postgresql start"
echo "msfdb init"
echo "msfconsole -q"
echo "db_import $OUTPUT_DIR/$FILE1.xml"
echo
echo -e "\e[034mCreate HTML Nmap Report\e[0m"
echo "xsltproc -o $OUTPUT_DIR/$FILE1.html $BOOTSTRAP $OUTPUT_DIR/$FILE1.xml"
sudo xsltproc -o $OUTPUT_DIR/$FILE1.html $BOOTSTRAP $OUTPUT_DIR/$FILE1.xml

echo
echo -e "\e[034mFinished - Nmap scan complete\e[0m"
sudo su -c "firefox $OUTPUT_DIR/$FILE1.html" kali > /dev/null 2>&1 & disown
echo

# GoWitness Screenshots
echo "Getting Screenshots using GoWitness...be patient"
sudo qterminal -e ./gowitness scan nmap -f "$OUTPUT_DIR/$FILE1.xml" --open-only --service-contains http --threads 25 --write-db > /dev/null 2>&1 & disown
echo

# Start GoWitness Server
echo -e "\e[034mStarting GoWitness Server at http://127.0.0.1:7171/\e[0m"
sudo qterminal -e ./gowitness report server > /dev/null 2>&1 & disown
wait
sudo -u kali firefox http://127.0.0.1:7171/gallery > /dev/null 2>&1 & disown
chmod -R 777 "$PWD"
echo
