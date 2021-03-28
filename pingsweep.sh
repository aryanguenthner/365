#!/bin/bash
#######################################################
# Discover Live Hosts by Doing a Ping Sweep
# Live Hosts Are Output To A File ips.txt
# Learn More @ https://github.com/aryanguenthner/
# Tested on Kali 2021.1
# Last updated 03/28/2021
######################################################

YELLOW='033m'
SUBNET=`ip r |awk 'NR==2' |awk '{print $1}'`
TARGETS=ips.txt
KALI=`hostname -I`

echo $KALI | awk '{print $1}' > KALI.txt

echo
echo -e "\e[033mGetting Network Information\e[0m"
echo
echo -e "\e[033mKali IP\e[0m"
echo $KALI | awk '{print $1}'
echo
echo -e "\e[033mThe Target Subnet\e[0m"
echo $SUBNET
echo
echo -e "\e[033mGenerating a Target List\e[0m"
nmap --stats-every=1m -sn -n $SUBNET --exclude $KALI -oG nmap-pingsweep
echo
echo -e "\e[033mThese Hosts Are Up\e[0m"
echo
cat nmap-pingsweep | grep "Up" | awk '{print $2}' 2>&1 | tee targets.txt
echo
echo -e "\e[033mTarget List Ouput File -> targets.txt\e[0m"
echo
echo -e "\e[033mUse nmap to enumerate more info on your targets:\e[0m"
echo
echo "nmap --stats-every=1m -T4 -Pn -v -sTV -p- --open --min-rate=5000 --min-hostgroup=256 --min-parallelism=256 --max-retries 0 -iL targets.txt -oA /home/kali/Desktop/testing/nmapscans"
echo -e '\r'
