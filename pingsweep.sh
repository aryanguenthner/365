#!/bin/bash
#######################################################
# Discover Live Hosts by Doing a Ping Sweep
# Live Hosts Are Output To A File ips.txt
# Learn More at https://github.com/aryanguenthner/
# Tested on Kali 2020.3
######################################################

YELLOW='033m'
EXCLUDE=excludefile.txt
SUBNET=`ip r |awk 'NR==2' |awk '{print $1}'`
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
echo $SUBNET
echo -e "\e[033mGenerating a Target List\e[0m"
nmap -sn -n $SUBNET --exclude $KALI -oG nmap
echo
echo -e "\e[033mThese Hosts Are Up\e[0m"
echo
cat nmap | grep "Up" | awk '{print $2}' 2>&1 | tee ips.txt
echo
echo -e "\e[033mTarget List Ouput File -> ips.txt\e[0m"
echo
echo -e "\e[033mUse nmap to enumerate more info on your targets\e[0m"
echo
echo "Try: nmap -iL ips.txt -vvvv -sT -A -p- -r --open --max-retries 0 -mtu 24 -oA nmapscan"
