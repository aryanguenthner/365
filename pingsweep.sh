#!/usr/bin/env bash

#######################################################
# Discover targets by doing a ping sweep
# Enumerate open ports and services
# Hosts that responded to ICMP are output to targets.txt 
# Learn More @ https://github.com/aryanguenthner/
# Tested on Kali 2024.2
# Last minor updated 08/23/2024
# The future is now
# Edit this script to fit your system
# Got Nmap?
######################################################

# Setting Variables
YELLOW=034m
BLUE=034m
EXT=$(curl -s ifconfig.me) 
KALI=$(hostname -I)
CITY=$(curl -s http://ip-api.com/line?fields=timezone | cut -d "/" -f 2)
SUBNET=$(ip r | awk 'FNR == 2 {print $1}')
TARGETS=targets.txt
FILE0=$(date +%Y%m%d).nmap-pingsweep_$RANDOM
FILE1=$(date +%Y%m%d).nmapscan_$RANDOM
BOOTSTRAP=nmap-bootstrap.xsl
NV=$(nmap -V | awk 'FNR == 1 {print $1,$2,$3}')
RANDOM=$$
PWD=$(pwd)
# MOBILE=TODO enable mobile alerts to be sent when scan is completed
SYNTAX="nmap --script http-screenshot --exclude $KALI -T4 -sV -Pn -sC -p- --open -vvvv --stats-every=1m --max-retries=0 --min-hostgroup=100 --min-parallelism=100 -iL $TARGETS -oA $PWD/$FILE1"
echo

# Depencency Check
echo -e "\e[034mRunning Dependency-check\e[0m"

# pingsweep checker
pingsweep=pingsweep.sh
if [ -f $pingsweep ]
then
    echo "Found pingsweep.sh"

else

    echo -e "\e[034mGetting pingsweep.sh from /opt/365e\e[0m"
cp /opt/365/pingsweep.sh $PWD
fi

echo "Found $NV"

# Nmap bootstrap file checker
NB=nmap-bootstrap.xsl
if [ -f $NB ]
then
    echo "Found nmap-bootstrap.xsl"

else

    echo -e "\e[034mCopying Missing $BOOTSTRAP File\e[0m"
    cp /opt/365/nmap-bootstrap.xsl /home/kali/Desktop/testing/nmapscans/

fi

# http-screenshot Checker
N=/usr/share/nmap/scripts/http-screenshot.nse
if [ -f $N ]
then
    echo "Found http-screenshot.nse"

else
    
    echo "Copying missing file http-screenshot.nse"
    cp -r /opt/365/http-screenshot.nse /usr/share/nmap/scripts
    nmap --script-updatedb > /dev/null 2>&1

fi
echo

# Todays Date
echo -e "\e[034mToday is\e[0m"
date
echo

# Screenshots
echo -e "\e[034mScreenshots Saved to --> $PWD/\e[0m"

# Networking
echo
echo -e "\e[034mGetting Network Information\e[0m"
echo
echo -e "\e[034mPublic IP\e[0m"
echo $CITY
echo $EXT
echo
echo -e "\e[034mKali IP\e[0m"
echo $KALI | awk '{print $1}'
echo
echo -e "\e[034mThe Target Subnet\e[0m"
echo $SUBNET
sleep 5
echo

echo -e "\e[034mGenerating a Target List\e[0m"

# First Lets do a Ping Sweep
echo
nmap $SUBNET -vvvv --stats-every=1m -sn -n --exclude $KALI -oG $FILE0 && cat $FILE0 | grep --color=always "hosts up"
echo
echo -e "\e[034mTarget List File -> targets.txt\e[0m"
echo
echo
echo -e "\e[034mPing Sweep Completed\e[0m"
echo
cat $FILE0 | grep "Up" | awk '{print $2}' 2>&1 | tee targets.txt
echo
echo -e "\e[034mUsing nmap to enumerate more info on your targets\e[0m"
echo
sleep 5
echo -e "\e[034mHack The Planet\e[0m"
echo "$SYNTAX"
echo

# Finally Lets Run the Nmap Scan
nmap --script http-screenshot --exclude $KALI -T4 -sV -Pn -sC -p- --open -vvvv --stats-every=1m --max-retries=0 --min-hostgroup=100 --min-parallelism=100 -iL $TARGETS -oA $PWD/$FILE1
echo
echo -e "\e[034mMetasploit\e[0m"
echo "service postgresql start"
echo "msfdb init"
echo "msfconsole -q"
echo "db_import $FILE1.xml"
echo
echo -e "\e[034mCreate HTML Nmap Report\e[0m"
echo "xsltproc -o $FILE1.html $BOOTSTRAP $FILE1.xml"
echo
xsltproc -o $FILE1.html $BOOTSTRAP $FILE1.xml
echo
echo -e "\e[034mFinished - Nmap scan complete\e[0m"
echo

# Pay me later
updatedb
chmod -R 777 .

sudo su -c "firefox $FILE1.html" kali

: '

TARGETS=targets.txt
BOOTSTRAP=nmap-bootstrap.xsl
RANDOM=$$
SCAN=$(date +%Y%m%d).nmapscan_$RANDOM
PWD=$(pwd)


nmap -iL subnets.txt --excludefile excludefile.txt -T4 -sV -Pn -p 21,22,23,25,53,80,443,135,137,139,445,389,554,587,902,990,992,1023,3389,3940,8000,8080,8081,8443,1433,3606,5060,5061,5900,27017 --open -vvvv --stats-every=1m --min-rtt-timeout=30ms --max-rtt-timeout=90ms --max-retries=0 --max-scan-delay=0 --min-rate=100 --min-hostgroup=100 --osscan-limit --max-os-tries=1 --script=ssl-cert,ssl-enum-ciphers,ssl-heartbleed,sip-enum-users,sip-brute,sip-methods,rtsp-screenshot,rtsp-screenshot,rpcinfo,vnc-screenshot,x11-access,x11-screenshot,nfs-showmount,nfs-ls,smb-security-mode,smb2-security-mode,smb-enum-shares,smb-ls,http-screenshot,http-sql-injection,smtp-open-relay,ftp-anon,ftp-bounce,ms-sql-config,ms-sql-info,ms-sql-empty-password,mysql-info,mysql-empty-password,vnc-brute,vnc-screenshot,vmware-version,http-shellshock,http-default-accounts,smb-vuln-ms08-067,smb-vuln-ms17-010,rdp-vuln-ms12-020,vuln,mainframe-banner,mainframe-screenshot,ssh-auth-methods,http-vuln-cve2017-5638 -oA nmap-scanname-date- && ./txt-alert.sh

xsltproc -o $FILE1.html $BOOTSTRAP $SCAN.xml
'
