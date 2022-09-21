#!/bin/bash
#######################################################
# Discover targets by doing a ping sweep
# Hosts that responded to ICMP are output to targets.txt 
# Learn More @ https://github.com/aryanguenthner/
# Tested on Kali 2022.4
# Last updated 09/21/2022
# The future is now
######################################################
# Stay Organized
chmod -R 777 /home/kali/Desktop/
mkdir -p /home/kali/Desktop/testing/nmapscans/
cd /home/kali/Desktop/testing/nmapscans
# Setting Variables
YELLOW=033m
BLUE=034m
EXT=`curl ifconfig.me`
KALI=`hostname -I`
SUBNET=`ip r | awk 'NR==2' | awk '{print $1}'`
TARGETS=targets.txt
RANDOM=$$
FILE0=$(date +%Y%m%d).nmap-pingsweep_$RANDOM
FILE1=$(date +%Y%m%d).nmapscan_$RANDOM
BOOTSTRAP=nmap-bootstrap.xsl
echo
echo -e "\e[034mRunning Dependency-check\e[0m"
echo
# Nmap bootstrap file checker
# If file exists skip the download
# if file is missing download it
NB=nmap-bootstrap.xsl
echo "Nmap Bootstrap File Checker"
echo
if [ -f $NB ]
then
    echo "File found: nmap-bootstrap.xsl"

else

    echo "Downloading $BOOTSTRAP File"
wget https://raw.githubusercontent.com/aryanguenthner/nmap-bootstrap-xsl/stable/nmap-bootstrap.xsl >/dev/null

fi
echo
# PhantomJS Checker
# Used for nmap screenshots
echo "PhantomJS Checker"
P=`phantomjs -v`
echo
if [ $P=1.9.8 ]
then
    echo "Found PhantomJS"

phantomjs -v
else

    echo "Downloading Missing PhantomJS"
cd /tmp
echo
wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.8-linux-x86_64.tar.bz2 >/dev/null
echo
echo "Extracting and Installing PhantomJS 1.9.8"
tar xvf phantomjs-1.9.8-linux-x86_64.tar.bz2 >/dev/null
mv phantomjs-1.9.8-linux-x86_64 phantomjs
mv phantomjs /opt
ln -s /opt/phantomjs/bin/phantomjs /usr/local/bin/phantomjs
phantomjs -v
echo
fi
echo
echo "Got Nmap Screenshots?"
N=/usr/share/nmap/scripts/http-screenshot.nse
if [ -f $N ]
then
    echo "File found: http-screenshot.nse"

ls -l /usr/share/nmap/scripts/http-screenshot.nse
else

    echo "Downloading missing file http-screenshot.nse"
cd /usr/share/nmap/scripts
wget https://raw.githubusercontent.com/ivre/ivre/master/patches/nmap/scripts/http-screenshot.nse >/dev/null
fi
nmap --script-updatedb >/dev/null
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
# Ping Sweep
cd /home/kali/Desktop/testing/nmapscans/
nmap $SUBNET --stats-every=1m -sn -n --exclude $KALI -oG $FILE0
echo
echo
echo -e "\e[033mTarget List File -> targets.txt\e[0m"
echo
echo
echo -e "\e[033mPing Sweep Completed\e[0m"
echo

echo
cat $FILE0 | grep "Up" | awk '{print $2}' 2>&1 | tee targets.txt
echo
echo -e "\e[033m***Using nmap to enumerate more info on your targets***\e[0m"
echo
echo -e "\e[034mHack The Planet\e[0m"
echo
# Nmap Scan Syntax
nmap -iL $TARGETS --stats-every=1m -T4 -Pn -sCTV -p 0-65535 --open -vvvv --exclude $KALI --script=http-screenshot --max-retries=0 -oA "/home/kali/Desktop/testing/nmapscans/$FILE1" --stylesheet $BOOTSTRAP
echo
xsltproc -o $FILE1.html $BOOTSTRAP $FILE1.xml
echo
echo
echo "Nmap scan completed"
echo $(pwd)/$FILE1.html
chmod -R 777 .
echo

# Pay me later

: 'Great Enumeration Scripts -> ssl-cert,ssl-enum-ciphers,ssl-heartbleed,sip-enum-users,sip-brute,sip-methods,rtsp-screenshot,rtsp-url-brute,rpcinfo,vnc-screenshot,x11-access,x11-screenshot,nfs-showmount,nfs-ls,smb-vuln-ms08-067,smb-vuln-ms17-010,smb-ls,smb-enum-shares,http-robots.txt.nse,http-webdav-scan,http-screenshot,http-enum --script-args=http-enum.basepath=200,http-auth --script-args=http-auth.path=/login,http-form-brute,http-sql-injection,http-ntlm-info --script-args=http-ntlm-info.root=/root/,http-git,http-open-redirect,http-vuln-cve2017-5638 --script-args=path=/welcome.action,http-open-proxy,socks-open-proxy,smtp-open-relay,ftp-anon,ftp-bounce,ms-sql-config,ms-sql-info,ms-sql-empty-password,mysql-info,mysql-empty-password,vnc-brute,vnc-screenshot,vmware-version,http-shellshock,http-default-accounts,http-passwd --script-args=http-passwd.root=/test/,smb-vuln-ms17-010,rdp-vuln-ms12-020,vuln,grab_beacon_config,vmware-version,smtp-vuln-cve2020-28017-through-28026-21nails.nse
'
