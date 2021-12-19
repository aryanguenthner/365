#!/bin/bash
#######################################################
# Discover IPv6 targets by doing a ping sweep
# Hosts that responded to ICMP are output to targets.txt 
# Learn More @ https://github.com/aryanguenthner/
# Tested on Kali 2021.4
# Last updated 12/18/2021
######################################################

YELLOW='033m'
BLUE='034m'
SUBNET=`nmap --iflist | awk 'NR==9' | awk '{print $3}'`
TARGETS=ips.txt
KALI=`hostname -I`
EXT=`curl ifconfig.me`
FILE=$(date +%Y%m%d).nmap-pingsweep
mkdir -p /home/kali/Desktop/testing

#
echo $KALI | awk '{print $1}' > KALI.txt
#
echo
echo -e "\e[033mGetting Network Information\e[0m"
echo
echo -e "\e[033mExternal IP\e[0m"
echo $EXT
echo
echo -e "\e[033mKali IP\e[0m"
echo $KALI | awk '{print $1}'
echo
echo -e "\e[033mThe Target Subnet\e[0m"
echo $SUBNET
echo
echo -e "\e[033mGenerating a Target List\e[0m"
nmap -6 --stats-every=1m -sn -n $SUBNET --exclude $KALI -oG $(date +%Y%m%d).nmap-pingsweep
echo
#echo -e "\e[033mThese Hosts Are Up\e[0m"
echo  -e "\033[33;5mThese Hosts Are Up\033[0m"
echo
cat $FILE | grep "Up" | awk '{print $2}' 2>&1 | tee targets.txt
echo
echo -e "\e[033mTarget List Ouput File -> targets.txt\e[0m"
echo
echo -e "\e[033mUse nmap to enumerate more info on your targets:\e[0m"
echo
echo "nmap -6 --stats-every=1m -T4 -Pn -vvvv -sTV -p- --open --script http-screenshot --min-rate=5000 --min-hostgroup=256 --min-parallelism=256 --max-retries 0 -iL targets.txt -oA /home/kali/Desktop/testing/$(date +%Y%m%d)_nmapscan"
