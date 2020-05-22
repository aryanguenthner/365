#!/bin/bash
################################################
# Ubuntu Updater Script
# Tested on 18.04.x64
# If you're reading this pat yourself on the back
# dos2unix updater.sh
# chmod +x updater.sh 
# Usage: ./updater.sh | tee updatelog.txt
# Learn more at https://github.com/aryanguenthner/
# Last Updated 04/18/2020
################################################
echo
date
echo
echo "Updates Should Be Like A Bolt of Lightning"
echo
echo
echo
echo "Properly Updating"
echo
echo
echo "We Will Be Rebooting"
echo
echo
apt update && apt -y upgrade && apt clean && apt -y autoremove
echo
echo
echo "Don't Blink"
#Go Ducks!
