#!/bin/bash

################################################
# Discovery Phase of a Penetration Test
# Tested On Kali 2019.3
# Get the IP Address of Your Target
# This is an Interactive Script
# Results are saved in ip.txt
# Usage: ./getip.sh
# Learn more at https://github.com/aryanguenthner
# Last Updated 2019-10-15
################################################
echo
echo "Usage: ./getip.sh"
echo
echo "Get the IP address of your target"
echo
echo -n "Enter Target's Domain Name ie. example.com: "
read domain
echo
echo "Give it a sec, it's getting real"
echo
echo
# If it all worked then the IP Address will be in ip.txt
ping -c 1 $domain | tee ping.txt | awk 'NR==1' | tr -d '()' | awk '{print $3}' | tee ip.txt
echo
echo "Saving IP address into ip.txt"
echo
echo
# Best Team Ever!
echo "Go Ducks!"
