#!/bin/bash
#######################################################
# Discover Live Hosts by Doing a Ping Sweep
# Live Hosts Are Output To A File targets.txt
# Learn More at https://github.com/aryanguenthner/
# Tested on Kali 2020.1
######################################################

YELLOW='033m'
EXCLUDE=excludefile.txt
SUBNET=subnet.txt
TARGETS=targets.txt
#KALI=`ifconfig eth0 | grep "inet" | awk '{print $2}' | awk 'NR==1'` > excludefile.txt
KALI=`hostname -I`

echo
echo -e "\e[033mGetting Networking Information\e[0m"
# dhclient & > /dev/null
echo
echo -e "\e[033mKali IP\e[0m"
hostname -I
echo
echo -e "\e[033mThe Target Subnet\e[0m"
nmap --iflist | awk 'NR==9' | awk '{print $1}' 2>&1 | tee subnet.txt
echo
echo -e "\e[033mGenerating a Target List\e[0m"
nmap -sn -n -iL $SUBNET --exclude $KALI -oG nmap
echo
echo -e "\e[033mThese Hosts Are Up\e[0m"
echo
cat nmap | grep "Up" | awk '{print $2}' 2>&1 | tee targets.txt
echo
echo -e "\e[033mTarget File Created targets.txt\e[0m"
echo
echo -e "\e[033mUse nmap to get more info on your targets\e[0m"
echo
echo "nmap -iL targets.txt -sT -A -p- -r --open --max-retries 0 -oA nmapscan"
