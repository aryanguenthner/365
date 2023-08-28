#!/usr/bin/env bash

#######################################################
# Made for doing security research on the Dark Deep Web
# Intended to be used on Kali Linux
# eye -q "ransomeware" | grep .onion > results+onions.txt
# torghost -a -c us,mx,ca 
# libreoffice --calc results+onions.txt
# Tested on Kali 2023.3
# Last updated 08/27/2023, minor evil updates
# https://github.com/aryanguenthner
# The future is now
# https://dark.fail/
# https://addons.mozilla.org/en-US/firefox/addon/noscript/
# https://addons.mozilla.org/en-US/firefox/addon/adblock-plus/
# https://chrome.google.com/webstore/detail/noscript/doojmbjmlfjjnbmnoijecmcbfeoakpjm/related?hl=en
# http://guideeedvgbpkthetphncab5aqj7dp5t74y7vxsoonnvmaeamq74vuqd.onion/
######################################################
echo "
██████╗░░█████╗░██████╗░██╗░░██╗░██████╗██╗░░██╗███████╗███████╗████████╗░██████╗
██╔══██╗██╔══██╗██╔══██╗██║░██╔╝██╔════╝██║░░██║██╔════╝██╔════╝╚══██╔══╝██╔════╝
██║░░██║███████║██████╔╝█████═╝░╚█████╗░███████║█████╗░░█████╗░░░░░██║░░░╚█████╗░
██║░░██║██╔══██║██╔══██╗██╔═██╗░░╚═══██╗██╔══██║██╔══╝░░██╔══╝░░░░░██║░░░░╚═══██╗
██████╔╝██║░░██║██║░░██║██║░╚██╗██████╔╝██║░░██║███████╗███████╗░░░██║░░░██████╔╝
╚═════╝░╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░░╚═╝╚═════╝░╚═╝░░╚═╝╚══════╝╚══════╝░░░╚═╝░░░╚═════╝░"
echo "v1.1"

# Setting Variables
YELLOW=033m
BLUE=034m
KALI=$(hostname -I)
CITY=$(curl -s http://ip-api.com/line?fields=timezone | cut -d "/" -f 2)
EXT=$(curl -s api.ipify.org)
PWD=$(pwd)
echo

# Check for Updates
echo -e "\e[033mCheck for updates y/n: \e[0m"
read UPS
if [ $UPS == y ]
then
    echo
    echo "Running apt-get update"
    sudo apt-get update > /dev/null 2>&1
    echo
    echo
else
    echo
    echo "Maybe next time"

fi
echo

# Check Tor Connectivity
echo -e "\e[033mCheck Tor connectivity y/n: \e[0m"
read TOR
if [ $TOR == y ]
then
    echo
    echo "Checking Tor Connection"
    curl -x socks5h://localhost:9050 -s https://check.torproject.org/api/ip | grep "true"
    echo
    echo
else
    echo
    echo "Maybe next time"

fi
echo


# Todays Date
timedatectl set-timezone America/Los_Angeles
echo -e "\e[034mToday is\e[0m"
date '+%Y-%m-%d %r' | tee darksheets-install.date
echo

# Editing Firefox about:config this allows DarkWeb .onion links to be opened with Firefox
echo 'user_pref("network.dns.blockDotOnion", false);' > user.js
mv user.js /home/kali/.mozilla/firefox/*default-esr/

echo "For the best results run as root: sudo ./darksheets.sh"
echo

# Networking
echo -e "\e[034mGetting Network Information\e[0m"
echo
echo -e "\e[033mPublic IP\e[0m"
echo $CITY
echo $EXT
echo
echo -e "\e[033mKali IP\e[0m"
echo $KALI | awk '{print $1}'
echo
sleep 1

# Make sure everything is installed for this to work
echo -e "\e[033mRequirements Check\e[0m"
echo
# Get NoScript Addons
XPI0=/home/kali/.mozilla/firefox/*default-esr/extensions/{73a6fe31-595d-460b-a920-fcc0f8843232}.xpi
if [ -f $XPI0 ]
then

    echo "Found NoScript Addon"

else

    echo "Downloading and Installing Addons"
    echo
    echo "Click Add to install the addon"
    echo
    wget -O noscript-11.4.26.xpi https://addons.mozilla.org/firefox/downloads/file/4141345/noscript-11.4.26.xpi
    sudo qterminal -e sudo su -c "firefox noscript-11.4.26.xpi" kali;

fi
echo

# Get Adblock Addons
XPI1=/home/kali/.mozilla/firefox/*default-esr/extensions/{d10d0bf8-f5b5-c8b4-a8b2-2b9879e08c5d}.xpi
if [ -f $XPI1 ]
then

    echo "Found Adblock Addon"

else

    echo "Downloading and Installing Addons"
    echo
    echo "Click Add to install the addon"
    echo
    wget -O adblock_plus-3.17.1.xpi https://addons.mozilla.org/firefox/downloads/file/4125998/adblock_plus-3.17.1.xpi
    sudo qterminal -e sudo su -c "firefox adblock_plus-3.17.1.xpi" kali;

fi
echo

# Get sponsorBlocker Addons
XPI2=/home/kali/.mozilla/firefox/*default-esr/extensions/sponsorBlocker@ajay.app.xpi
if [ -f $XPI2 ]
then

    echo "Found sponsorBlocker Addon"

else

    echo "Downloading and Installing Addons"
    echo
    echo "Click Add to install the addon"
    echo
    wget -O sponsorblock-5.4.15.xpi https://addons.mozilla.org/firefox/downloads/file/4151024/sponsorblock-5.4.15.xpi
    sudo qterminal -e sudo su -c "firefox sponsorblock-5.4.15.xpi" kali;

fi
echo
# Darksheet checker
DARK=/home/kali/Desktop/testing/dark-web/darksheets.sh
if [ -f "$DARK" ]
then
    echo "Found darksheets.sh"

else

    echo -e "\e[034mGetting darksheets.sh from /opt/365e\e[0m"
    cp /opt/365/darksheets.sh $PWD
fi
echo

E=/usr/local/bin/eye
if [ -f "$E" ]
then

    echo "Found The Devils Eye"

else

    echo "Getting the Devil"
    sudo pip install thedevilseye==2022.1.4.0

fi
echo

T=/opt/TorGhost/torghost.py
if [ -f "$T" ]
then

    echo "Found TorGhost"

else

    echo "Downloading TorGhost"
# Tor Web Browser Stuff
# Connect to Tor --> torghost -a -c us
# Disconnect Tor --> torghost -x
# Exit Tor --> torghost -x
# sudo gpg --keyserver pool.sks-keyservers.net --recv-keys EB774491D9FF06E2 && 
# Use Tor Browswer or FF to view the onion links
sudo apt-get install -y torbrowser-launcher

cd /opt
git clone https://github.com/aryanguenthner/TorGhost.git
cd TorGhost
sudo apt-get -y install python3-pyinstaller python3-notify2
echo "One moment please - Installing TorGhost"
sudo pip3 install . --ignore-installed stem > /dev/null 2>&1
sudo ./build.sh  > /dev/null 2>&1
echo

fi
echo

# Open the onion links with Libreoffice
O=/usr/bin/libreoffice
if [ -f "$O" ]
then

    echo "Found Libreoffice"

else

    echo "Installing Libreoffice"
apt-get -y install libreoffice

fi
echo

# User Input
echo -en "\e[034mWhat are you looking for: \e[0m"
read -e SEARCH
    echo "Be Patient"
    echo
    echo -ne '#####                     (33%)\r'
sleep 1
    echo -ne '#############             (66%)\r'
    sleep 1
    echo -ne '#######################   (100%)\r'
    echo -ne '\n'

eye -q "$SEARCH" | grep ".onion" > onions.txt
sed '/^invest/d' onions.txt > results+onions.txt
    echo


# First 10 Results
echo
echo -e "\e[033mTop Results\e[0m"
echo
head results+onions.txt
echo

echo "Saved results -->" results+onions.txt
echo
# Darksheets Results
echo -e "\e[033mOpen a darksheet with results y/n: \e[0m"
read OPEN1
    echo
# Open spreadsheet with results
if [ $OPEN1 == y ]
then
    echo -e "\e[033mdarksheet results\e[0m"
    echo "Exit DarkSheets: CTRL + c"
    echo
    echo "Use NoScript! Block Javascript!"
    echo
    echo "To continue press:    CTRL + c"
    sudo qterminal -e libreoffice --calc $PWD/results+onions.txt > /dev/null 2>&1

    echo "Close terminal press: CTRL + c"
else

    echo "Maybe next time"

fi
echo
HIT1=`awk 'FNR == 1 {print $1}' results+onions.txt`

# Connect to the Dark Web
echo -en "\e[033mConnect to the Dark Web y/n: \e[0m"
read -e DWEB0
    echo

if [ $DWEB0 == y ]
then

    echo "Attempting to enter the Dark Web"
    echo
    echo "Be Patient"
    echo
    echo -ne '#####                     (33%)\r'
sleep 1
    echo -ne '#############             (66%)\r'
    sleep 1
    echo -ne '#######################   (100%)\r'
    echo -ne '\n'
    echo
    curl -x socks5h://localhost:9050 -s https://check.torproject.org/api/ip | grep "true"
    echo
    echo
    torghost -a -c us,ca,mx,ca > /dev/null 2>&1
    echo

    echo -e "\e[033mDark Web IP\e[0m"
    echo $CITY

    echo $EXT
    echo
else
    echo "Maybe next time"
    echo

fi

# Open FF
echo -e "\e[033mOpen Firefox to view results y/n: \e[0m"
read -e OPEN2
    echo

if [ $OPEN2 == y ]
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

# Stay Organized
    echo "Results Saved to -->" $PWD/results+onions.txt
    echo

# Exit the Dark Web
    echo -n 'Exit the Dark Web y/n: '
    echo
read DWEB1
if [ $DWEB1 == y ]
then
    echo
    echo "Trying to Exit the Dark Web"
sudo torghost -x
    echo
    echo "Exit Tor type:   torghost -x"
    echo "Exit DarkSheets: CTRL + c"
    echo
    echo -e "\e[033mYour Public IP\e[0m"
    echo $CITY
    echo $EXT

else

    echo "Be good"
    echo
    echo "Exit Tor type: torghost -x"
fi
echo
