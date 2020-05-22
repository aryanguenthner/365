#!/bin/bash

##################################################
# Discover Live Hosts by doing a ping sweep
# Live Hosts Are Output To A File targets.txt
# Learn More at https://github.com/aryanguenthner/
# Tested on Kali 2020-05-07
##################################################

YELLOW='033m'
DATE=date
KALI=`hostname -I`
SUBNET='$KALI\24'
TARGETS=targets.txt

echo "Ping Sweep Date"
echo -e "\e[033m`date`\e[0m"
echo -e "\e[033mOutput Directory /home/kali/Desktop/nmap-collector/\e[0m"
echo
mkdir -p /home/kali/Desktop/nmap-collector/
echo -e "\e[033mGetting Networking Information\e[0m"
echo
echo -e "\e[033mKali IP\e[0m"
echo -e "\e[033m`hostname -I`\e[0m"
echo
echo -e "\e[033mThe Target Subnet\e[0m"
ip route | awk 'NR==2' | awk '{print $1}' 2>&1 | tee subnet.txt
echo
echo -e "\e[033mGenerating a Target List\e[0m"
nmap -iL $SUBNET -sn -n --exclude $KALI -oG nmap
echo
echo -e "\e[033mThese Hosts Are Up\e[0m"
echo
cat nmap | grep "Up" | awk '{print $2}' 2>&1 | tee targets.txt
echo
echo -e "\e[033mTarget File Created targets.txt\e[0m"
echo
echo -e "\e[033mUse nmap to get more info on your targets\e[0m"
echo
echo "nmap -iL targets.txt -mtu 24 -T4 -Pn -sS -A -r -p- --open --max-retries 0 -vvvv -oA nmapscan"
echo
mv subnet.txt targets.txt nmap* /home/kali/Desktop/nmap-collector/