#!/bin/bash
################################################
# Tested on Kali 2022.4
# Step 1 for any security testing
# Usage: ./start-tcpdump.sh
# Learn more at https://github.com/aryanguenthner
# Last Updated 2022-11-12
################################################
# Working Directory
echo -e "\e[034mCurrent Directory\e[0m"
echo $PWD
echo

# Todays Date
echo -e "\e[034mToday is\e[0m"
date
echo

# Networking
echo -e "\e[034mPublic IP Address\e[0m"
curl ifconfig.me
echo

echo -e "\e[034mKali IP Address\e[0m"
echo $KALI
echo
echo
echo "I recommend putting this script in screen"
echo
echo "If you don't want to use screen that's fine"
echo "screen -S packetcaputures"
echo "Optional: Exit this script, use screen then run: ./start-tcpdump.sh 2>&1 | tee packetlog.txt"
# Nice Interactive way to do Packet Captures
echo
echo "Nice Packet Captures!"
echo
echo -n "Specify Interface, Example eth0: "
read interface
echo -n "Specify Full Path of Output Directory: "
read directory
echo -n "Specify Output Name for Results: "
read name
echo
echo "Be Patient"
echo
tcpdump -i $interface -s 0 -n -vv -C 500 -z bzip2 -w $directory$name.pcap -Z root
echo
echo "tcpdump is running" 
echo
echo
# Oregon Ducks Are The Best Team Ever!
echo
echo "Go Ducks!"
