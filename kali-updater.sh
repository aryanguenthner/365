#!/bin/bash
################################################
# Kali Updater Script
# Tested on Kali 2020.1
# If you're reading this pat yourself on the back
# dos2unix kali-updater.sh
# chmod +x kali-updater.sh 
# Usage: ./kali-updater.sh | tee kaliupdatelog.txt
# Learn more at https://github.com/aryanguenthner/
# Last Updated 03/13/2020
################################################
echo
date
echo
echo "Kali Updates Should Be Like A Bolt of Lightning"
echo
echo
echo "Downloading The Official Kali Linux PGP Key for Secure Communication"
echo
wget -q -O - https://archive.kali.org/archive-key.asc  | apt-key add
echo
echo "Properly Updating Kali"
echo
echo
echo "We Will Be Rebooting"
echo
echo
apt update && apt -y upgrade && apt -y full-upgrade && apt clean && apt -y autoremove
echo
echo
echo "Don't Blink"
reboot
#Go Ducks!
