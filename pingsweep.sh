#!/usr/bin/env bash

#######################################################
# Discover targets by doing a ping sweep
# Enumerate open ports and services
# Hosts that responded to ICMP are output to targets.txt 
# Learn More @ https://github.com/aryanguenthner/
# Tested on Kali 2022.4
# Last updated 01/13/2023
# The future is now
# Edit this script to fit your system
# Got nmap?
######################################################

# Setting Variables
YELLOW=033m
BLUE=034m
EXT=`curl -s ifconfig.me`
KALI=`hostname -I`
SUBNET=`ip r | awk 'NR==2' | awk '{print $1}'`
TARGETS=targets.txt
FILE0=$(date +%Y%m%d).nmap-pingsweep_$RANDOM
FILE1=$(date +%Y%m%d).nmapscan_$RANDOM
BOOTSTRAP=nmap-bootstrap.xsl
NV=`nmap -V | awk 'NR==1' | cut -d " " -f 1,2,3`
RANDOM=$$
#LS=`ls`
PWD=`pwd`
SYNTAX="nmap -T4 -A -sCT -vvvv --stats-every=1m -Pn -p* --script http-screenshot,banner -iL $TARGETS --exclude $KALI -oA /home/kali/Desktop/testing/nmapscans/$FILE1 && cd /home/kali/Desktop/testing/nmapscans/"
echo

# Stay Organized
mkdir -p /home/kali/Desktop/testing/nmapscans/

# Depencency Check
echo -e "\e[034mRunning Dependency-check\e[0m"

# pingsweep checker
pingsweep=/home/kali/Desktop/testing/nmapscans/pingsweep.sh
if [ -f $pingsweep ]
then
    echo "Found pingsweep.sh"

else

    echo -e "\e[034mGetting pingsweep.sh from /opt/365e\e[0m"
cp /opt/365/pingsweep.sh /home/kali/Desktop/testing/nmapscans/
fi

echo "Found $NV"
cd /home/kali/Desktop/testing/nmapscans/

# Nmap bootstrap file checker
NB=nmap-bootstrap.xsl
if [ -f $NB ]
then
    echo "Found nmap-bootstrap.xsl"

else

    echo -e "\e[034mDownloading Missing $BOOTSTRAP File\e[0m"
wget -O /home/kali/Desktop/testing/nmapscans/nmap-bootstrap.xsl https://raw.githubusercontent.com/aryanguenthner/nmap-bootstrap-xsl/stable/nmap-bootstrap.xsl > /dev/null

fi

# PhantomJS Checker
P=/usr/local/bin/phantomjs
if [ -f $P ]
then

    echo "Found PhantomJS 1.9.8"

else

    echo -e "\e[034mDownloading Missing PhantomJS\e[0m"

wget --no-check-certificate -O /opt/phantomjs-1.9.8-linux-x86_64.tar.bz2 https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.8-linux-x86_64.tar.bz2
tar xvjf phantomjs-1.9.8-linux-x86_64.tar.bz2
rm phantomjs-1.9.8-linux-x86_64.tar.bz2

echo "Extracting and Installing PhantomJS 1.9.8"
cd /opt
tar xvf phantomjs-1.9.8-linux-x86_64.tar.bz2
mv phantomjs-1.9.8-linux-x86_64 phantomjs
mv phantomjs /opt
ln -s /opt/phantomjs/bin/phantomjs /usr/local/bin/phantomjs

    echo "Phantomjs Version"
phantomjs -v

fi

# http-screenshot Checker
N=/usr/share/nmap/scripts/http-screenshot.nse
if [ -f $N ]
then
    echo "Found http-screenshot.nse"

else

    echo -e "\e[034mDownloading missing file http-screenshot.nse\e[0m"
cd /usr/share/nmap/scripts
wget https://raw.githubusercontent.com/aryanguenthner/365/master/http-screenshot.nse
nmap --script-updatedb > /dev/null

fi
echo

# TODO add gowitness
: '# gowitness
gow=somefile
if [ -f $gow ]
then
    echo "Found gowitness"

else

    echo -e "\e[034mDownloading Missing $gow File\e[0m"
wget -O /home/kali/Desktop/testing/nmapscans/gowitness https://raw.githubusercontent.com/aryanguenthner/gowitness > /dev/null

fi
'
# Todays Date
echo -e "\e[034mToday is\e[0m"
date
echo

# Screenshots
echo -e "\e[034mScreenshots Saved to --> /home/kali/Desktop/testing/nmapscans/\e[0m"

# Networking
echo
echo -e "\e[033mGetting Network Information\e[0m"
echo
echo -e "\e[033mExternal IP\e[0m"
curl -s http://ip-api.com/line?fields=timezone | cut -d "/" -f 2

echo $EXT
echo
echo -e "\e[033mKali IP\e[0m"
echo $KALI | awk '{print $1}'
echo
echo -e "\e[033mThe Target Subnet\e[0m"
echo $SUBNET
sleep 5
echo

echo -e "\e[033mGenerating a Target List\e[0m"

# Ping Sweep
cd /home/kali/Desktop/testing/nmapscans/
nmap $SUBNET --stats-every=1m -sn -n --exclude $KALI -oG $FILE0 && cat $FILE0 | grep --color=always "hosts up"
echo
echo -e "\e[033mTarget List File -> targets.txt\e[0m"
echo
echo
echo -e "\e[033mPing Sweep Completed\e[0m"
echo
cat $FILE0 | grep "Up" | awk '{print $2}' 2>&1 | tee targets.txt
echo
echo -e "\e[033mUsing nmap to enumerate more info on your targets\e[0m"
echo
sleep 5
echo -e "\e[034mHack The Planet\e[0m"
echo "$SYNTAX"
echo

# Nmap Scan
nmap -T4 -A -sCT -vvvv --stats-every=1m -Pn -p* --script http-screenshot,banner --open -iL $TARGETS --exclude $KALI -oA /home/kali/Desktop/testing/nmapscans/$FILE1 && cd /home/kali/Desktop/testing/nmapscans/
echo
echo
xsltproc -o $FILE1.html $BOOTSTRAP $FILE1.xml
echo
echo "Import results into Metasploit"
echo msfconsole
echo db_import $(pwd)/$FILE1.xml
echo
echo "Nmap scan completed"
echo
sudo su -c "firefox $(pwd)/$FILE1.html" kali



# Pay me later
chmod -R 777 /home/kali/Desktop
updatedb

: 'Great Nmap Enumeration Scripts -> ssl-cert,ssl-enum-ciphers,ssl-heartbleed,sip-enum-users,sip-brute,sip-methods,rtsp-screenshot,rtsp-url-brute,rpcinfo,vnc-screenshot,x11-access,x11-screenshot,nfs-showmount,nfs-ls,smb-vuln-ms08-067,smb-vuln-ms17-010,smb-ls,smb-enum-shares,http-robots.txt.nse,http-webdav-scan,http-screenshot,http-enum --script-args=http-enum.basepath=200,http-auth --script-args=http-auth.path=/login,http-form-brute,http-sql-injection,http-ntlm-info --script-args=http-ntlm-info.root=/root/,http-git,http-open-redirect,http-vuln-cve2017-5638 --script-args=path=/welcome.action,http-open-proxy,socks-open-proxy,smtp-open-relay,ftp-anon,ftp-bounce,ms-sql-config,ms-sql-info,ms-sql-empty-password,mysql-info,mysql-empty-password,vnc-brute,vnc-screenshot,vmware-version,http-shellshock,http-default-accounts,http-passwd --script-args=http-passwd.root=/test/,smb-vuln-ms17-010,rdp-vuln-ms12-020,vuln,grab_beacon_config,vmware-version,smtp-vuln-cve2020-28017-through-28026-21nails.nse,banner
'
