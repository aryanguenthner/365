#!/bin/bash
################################################
# Tested on Kali 2020.1
# Here is the order of operation to successfully use this script
# Do this: dos2unix *.sh && chmod +x *.sh
# Use the nmap-parser.py before using this script
# Counter Usage: ./counter.sh
# Learn more at https://github.com/aryanguenthner/
# Last Updated 2020-03-28
################################################
echo
echo "Discover How Many Products Are In Your Environment"
echo
# If you used the nmap-parser.py you will have a file named results.csv
echo
# Getting The Results Ready
cat results.csv | grep -v tcpwrapped > cleaned.csv &&
cat cleaned.csv | sort  > file.csv &&
cat file.csv | sort -n | uniq -c > counted.csv &&
cat counted.csv | sed 's/Host is up//g; s/open//g; s/syn-ack//g' > tally.csv &&
cat tally.csv | tr --delete '()' > total.csv
echo
# Print Out The Top Results
echo -e "Occurances"
echo -e "Port Number  	   Protocol     Service Version"

# Saving results to a file
cat total.csv | sort -n

echo "Saving to tally.csv"
# The Best College Football Team Ever
# echo "Go Ducks!"