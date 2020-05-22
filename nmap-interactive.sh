#!/bin/bash
################################################
# Tested On Kali 2020.1 x64
# Fast Nmap Enumeration Interactive Script
# Do You Have Your Targets Identified? Use the Discovery and Masscan Scripts It Might Help
# Do this: dos2unix *.sh
# Do this: chmod +x *.sh
# Usage: ./nmap-interactive.sh
# Learn more at https://github.com/aryanguenthner
# Last Updated 2020-03-27
################################################
echo
date
echo "Nmap Enumeration"
echo
echo -n "Enter the Target IP, Subnet, Input File use -iL: "
read target
echo
echo  "Which ports you want to scan? Example: 21,22,23"
echo
echo -n "Enter The Port Numbers Remember To Use Commas: "
read ports
echo
echo -n "Specify The Output Name For Results: "
read name
echo
echo "It's Getting Real, Be Patient"
nmap -A -T5 -sT --open -r -vvv --max-retries 0 --max-parallelism 100 -p$ports -oA $name $target
echo
echo "Saving Output" 
echo
echo "Use The Nmap File Parser To See Detailed Results"
echo
echo "Usage: ./nmap-parser.py "$name".gmap"
