#!/bin/bash
#######################################################
# Discover Live Hosts by Doing a Ping Sweep
# Live Hosts Are Output To A File ips.txt
# Learn More @ https://github.com/aryanguenthner/
# Tested on Kali 2020.3
# Last updated 11/17/2020
######################################################

YELLOW='033m'
SUBNET=`ip r |awk 'NR==2' |awk '{print $1}'`
TARGETS=ips.txt
KALI=`hostname -I`

echo
echo -e "\e[033mGetting Networking Information\e[0m"
echo
echo -e "\e[033mKali IP\e[0m"
hostname -I
echo
echo -e "\e[033mThe Target Subnet\e[0m"
echo $SUBNET
echo
echo -e "\e[033mGenerating a Target List\e[0m"
nmap -sn -n $SUBNET --exclude $KALI -oG nmap-pingsweep
echo
echo -e "\e[033mThese Hosts Are Up\e[0m"
echo
cat nmap-pingsweep | grep "Up" | awk '{print $2}' 2>&1 | tee ips.txt
echo
echo -e "\e[033mTarget List Ouput File -> ips.txt\e[0m"
echo
echo -e "\e[033mUse nmap to enumerate more info on your targets:\e[0m"
echo
echo "nmap -iL ips.txt -vvvv -sT -A -p- -r --open --max-retries 0 -mtu 24 -oA /home/kali/Desktop/nmapscans"
echo -e '\r'
