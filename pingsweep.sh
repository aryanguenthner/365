#!/bin/bash
#######################################################
# Discover targets by doing a ping sweep
# Hosts that responded to ICMP are output to targets.txt 
# Learn More @ https://github.com/aryanguenthner/
# Tested on Kali 2022.1
# Last updated 04/13/2022
######################################################
# Setting Variables
YELLOW='033m'
BLUE='034m'
SUBNET=`ip r |awk 'NR==2' |awk '{print $1}'`
TARGETS=ips.txt
KALI=`hostname -I`
EXT=`curl ifconfig.me`
RANDOM=$$
FILE0=$(date +%Y%m%d).nmap-pingsweep_$RANDOM
FILE1=$(date +%Y%m%d).nmapscan_$RANDOM
echo
# Nmap bootstrap file checker
# If file exists skip the download
# if file is missing download it
N='nmap-bootstrap.xsl'
echo "Nmap Bootstrap File Checker"
echo
if [ -f $N ]
then
    echo "File Found: nmap-bootstrap.xsl"

else

    echo "Downloading Missing File"
    wget https://raw.githubusercontent.com/aryanguenthner/nmap-bootstrap-xsl/stable/nmap-bootstrap.xsl

fi
echo
echo $KALI | awk '{print $1}' > KALI.txt
echo
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
nmap --stats-every=1m -sn -n $SUBNET --exclude $KALI -oG $FILE0
echo
echo -e "\e[033mPing Sweep Completed\e[0m"
echo
#echo -e "\e[033mThese Hosts Are Up\e[0m"
echo  -e "\033[33;5mThese Hosts Are Up\033[0m"
echo
cat $FILE0 | grep "Up" | awk '{print $2}' 2>&1 | tee targets.txt
echo
echo -e "\e[033mTarget List Ouput File -> targets.txt\e[0m"
echo
echo -e "\e[033m***Using nmap to enumerate more info on your targets***\e[0m"
echo
echo "Hack The Planet Happening Now"
echo
echo
nmap --stats-every=1m -T4 -Pn -vv -sCTV -p- --open --script http-screenshot,http-passwd --script-args http-passwd.root=/test/ --min-rate=1000 --min-hostgroup=128 --min-parallelism=128 --max-retries 0 -oA /home/kali/Desktop/testing/$FILE1 --stylesheet nmap-bootstrap.xsl $SUBNET
echo
xsltproc -o $FILE1.html nmap-bootstrap.xsl $FILE1.xml
echo
# TODO su kali
# firefox $FILE1.html
# Pay me later

: 'ssl-cert,ssl-enum-ciphers,ssl-heartbleed,sip-enum-users,sip-brute,sip-methods,rtsp-screenshot,rtsp-url-brute,rpcinfo,vnc-screenshot,x11-access,x11-screenshot,nfs-showmount,nfs-ls,smb-vuln-ms08-067,smb-vuln-ms17-010,smb-ls,smb-enum-shares,http-robots.txt.nse,http-webdav-scan,http-screenshot,http-enum --script-args=http-enum.basepath=200,http-auth --script-args=http-auth.path=/login,http-form-brute,http-sql-injection,http-ntlm-info --script-args=http-ntlm-info.root=/root/,http-git,http-open-redirect,http-vuln-cve2017-5638 --script-args=path=/welcome.action,http-open-proxy,socks-open-proxy,smtp-open-relay,ftp-anon,ftp-bounce,ms-sql-config,ms-sql-info,ms-sql-empty-password,mysql-info,mysql-empty-password,vnc-brute,vnc-screenshot,vmware-version,http-shellshock,http-default-accounts,http-passwd --script-args=http-passwd.root=/test/,smb-vuln-ms17-010,rdp-vuln-ms12-020,vuln,grab_beacon_config,vmware-version,smtp-vuln-cve2020-28017-through-28026-21nails.nse

'
