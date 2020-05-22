#!/bin/bash

################################################
# Recon Phase of a Penetration Test
# Tested On Kali 2019.3
# Discover CIDR, Netrange, and Organization Info
# This is an Interactive Script
# First Make The File Executable chmod +x *.sh
# Usage: ./getcider.sh
# Learn more at https://github.com/aryanguenthner
# Last Updated 2019-10-15
################################################
echo
echo "Usage: ./get-cidr.sh"
echo
echo "Get the CIDR / Net Range / Organization Info of an IP Address"
echo
echo -n "Enter the Target IP address: "
read address
echo
echo "Be Patient"
echo
echo "Saving CIDR Results to cidr.txt"
echo
whois $address > whois.txt && cat whois.txt | grep -w 'NetRange\|CIDR\|Organization' | tee cidr.txt
echo
echo "Saving Target's Subnets to subnetlist.txt"
cat cidr.txt | grep -i 'CIDR' > subnets.txt
cat subnets.txt | awk '{print $2}'> subnetlist.txt
echo
echo "How far are you going down the rabbit hole?"
echo
echo "Try masscan,nmap or rawr"
echo
#Go Ducks!
