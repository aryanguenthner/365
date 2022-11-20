#!/usr/bin/env bash
#######################################################
# Discover targets by doing a ping sweep
# eye -q "vice lausd" | grep .onion > results+onions.txt
# torghost -a -c ca 
# libreoffice --calc results+onions.txt
# Tested on Kali 2022.4
# Last updated 11/18/2022
# The future is now
######################################################
# Setting Variables
YELLOW=033m
BLUE=034m
KALI=`hostname -I`
LS=`ls`
PWD=`pwd`
echo

# Todays Date
echo -e "\e[034mToday is\e[0m"
date
echo

# Files
echo -e "\e[034mFiles in your current directory -->$PWD\e[0m"
echo "$LS"
sleep 1
echo

# Networking
echo
echo -e "\e[034mGetting Network Information\e[0m"
echo
echo -e "\e[033mPublic IP\e[0m"
curl -s ifconfig.me
echo
echo
echo -e "\e[033mKali IP\e[0m"
echo $KALI | awk '{print $1}'
echo
echo
echo -e "\e[033mRequirements Check\e[0m"
echo
E=/usr/local/bin/eye
if [ -f "$E" ]
then

    echo "Found The Devils Eye"

else

    echo "Getting the Devil"
pip install thedevilseye

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
# Exit Tor -->torghost -x
# sudo gpg --keyserver pool.sks-keyservers.net --recv-keys EB774491D9FF06E2 && 
# Use Tor Browswer to view the onion links
sudo apt-get -y install torbrowser-launcher

cd /opt
git clone https://github.com/aryanguenthner/TorGhost.git
cd TorGhost
sudo apt -y install python3-pyinstaller python3-notify2
echo "One moment please - Installing TorGhost"
sudo pip3 install . --ignore-installed stem > /dev/null
sudo ./build.sh > /dev/null
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
apt update && apt -y install libreoffice

fi
echo

echo "Let's Get Evil Onions"
echo

# User Input
echo -en "\e[034mWhat are you looking for: \e[0m"
read SEARCH
echo

eye -q "$SEARCH" | grep .onion > results+onions.txt
echo "Be Patient"
echo

echo "Saved results into" results+onions.txt
echo

head results+onions.txt
echo

echo "How many evil onion links did we find?"
wc results+onions.txt
echo
sleep 2
echo

echo -n 'Connect to the Dark Web y/n: '
read DWEB0
echo
echo

if [ $DWEB0 == y ]
then

echo "Trying to get on the Dark Web"
torghost -a -c us
echo

echo -e "\e[033mNew Public IP\e[0m"
curl -s ifconfig.me
echo
else

echo "Maybe next time"

fi
echo

# Add http prefix to onion links
for x in $(cat results+onions.txt); do echo http://$x; done > results.txt;
echo
echo "Top 10 Results"
echo

echo "Be Good"
head results.txt
echo

# Spreadsheet Results
echo -n 'Open spreadsheet with results in y/n: '
read OPEN1
echo

if [ $OPEN1 == y ]
then

echo "Here they are"
libreoffice --calc results+onions.txt;

else

echo "Maybe next time"

fi
echo

# Fix Permissions for kali
chmod -R 777 /home/kali

# Exit the Dark Web
echo -n 'Exit the Dark Web y/n: '
read DWEB1
echo
echo
if [ $DWEB1 == y ]
then

echo "Trying to Exit the Dark Web"
torghost -x
echo

echo -e "\e[033mNew Public IP\e[0m"
curl -s ifconfig.me
echo
else

echo "Be good"

fi
echo




