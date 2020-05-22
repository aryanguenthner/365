#!/bin/bash
################################################
# Tested On Kali 2019.3
# Convert a List of IP Address Line Seperated and Append them with "http://"
# Usage: ./ips-to-urls.sh
# Learn more at https://github.com/aryanguenthner
# Last Updated 10/15/2019
################################################
echo
echo -n "Enter Full Path to the File with IP Addresses: "
read  file
for i in $(cat $file); do echo http://$i; done > urls.txt &&
mkdir -p /root/Desktop/urls
mv urls.txt /root/Desktop/urls
echo
echo "Output File: /root/Desktop/urls"
echo
echo
# Best Team Ever
# Go Ducks!
