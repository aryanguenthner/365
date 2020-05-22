#!/usr/bin/env bash

################################################
# Fast Masscan Enumeration Interactive Script
# Do You Have Your Targets Identified? Use the Discovery tool It Might Help
# First Make The File Executable chmod +x *.sh
# Usage: ./masscan.sh
# Learn more at https://github.com/aryanguenthner
# Last Updated 2018-03-01
################################################
echo
echo "Usage: ./masscan-interactive.sh"
echo
echo "So You Wanna Scan All The Things?"
echo
echo -n "Enter The Target IP, Subnet, Input File Use -iL: "
read target
echo
echo -n "Which Ports Do You Want To Scan? Remember To Use Commas: "
read ports
echo
echo -n "Enter The Output File Name: "
read name
echo
# Masscan Is the Fast Scan
echo "Don't Blink, This Is Fast"
masscan -v --open --rate 2000 $target -p$ports -oG $name && 
cat $name | grep open | awk '{print $2}' > ips.txt 
echo
echo "Saving Target Output To ips.txt"
echo
echo
echo "Use nmap To Get Detailed Results"
# Use The Interactive Script For Excellent Results
echo "./nmap-interactive.sh"
# Best Team Ever!
echo "Go Ducks!"
