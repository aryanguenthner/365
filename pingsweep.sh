#!/bin/bash
#######################################################
# Discover targets by performing an ICMP ping sweep
# Hosts that responded to ICMP are output to targets.txt 
# Learn more @ https://github.com/aryanguenthner/
# Tested on Kali 2021.4
# Last updated 01/30/2022
######################################################
#
YELLOW='033m'
BLUE='034m'
SUBNET=`ip r |awk 'NR==2' |awk '{print $1}'`
TARGETS=ips.txt
KALI=`hostname -I`
EXT=`curl ifconfig.me`
FILE=$(date +%Y%m%d).nmap-pingsweep
RANDOM=$$
NMAP_FILE=$(date +%Y%m%d)_nmapscan_$RANDOM
#
mkdir -p /home/kali/Desktop/testing/nmapscans
cd /home/kali/Desktop/testing/nmapscans && chmod -R 777 .
#
echo $KALI | awk '{print $1}' > KALI.txt
#
echo
echo -e "\e[033mGetting Network Information\e[0m"
echo
echo -e "\e[033mKali Public IP\e[0m"
echo $EXT
echo
echo -e "\e[033mKali Internal IP\e[0m"
echo $KALI | awk '{print $1}'
echo
echo -e "\e[033mThe Target Subnet\e[0m"
echo $SUBNET
echo
echo -e "\e[033mGenerating a Target List\e[0m"
nmap --stats-every=1m -sn -n $SUBNET --exclude $KALI -oG $(date +%Y%m%d).nmap-pingsweep
echo
#echo -e "\e[033mThese Hosts Are Up\e[0m"
echo  -e "\033[33;5mThese Hosts Are Up\033[0m"
echo
cat $FILE | grep "Up" | awk '{print $2}' 2>&1 | tee targets.txt
echo
echo -e "\e[033mTarget List Ouput File -> targets.txt\e[0m"
echo
echo -e "\e[033mStarting enumeration on hosts in targets.txt:\e[0m"
echo
nmap --stats-every=1m -T4 -Pn -vvvv -sCVT -p- --open --script=http-screenshot,vuln --script-args=mincvss=7.5, --min-rate=5000 --min-hostgroup=256 --min-parallelism=256 --max-retries=0 -iL targets.txt -oA /home/kali/Desktop/testing/nmapscans/$NMAP_FILE --stylesheet nmap-bootstrap.xsl && xsltproc -o $NMAP_FILE.html nmap-bootstrap.xsl $NMAP_FILE.xml && ./txt-alert.sh
#
: '
./txt-alert.sh && nmap -T4 -sCVT -Pn -p- -vvvv --open --stats-every=1m --min-rate=5000 --min-hostgroup=256 --min-parallelism=256 --max-retries=0 --script-timeout=2m --script=vuln --script-args=mincvss=7.5,ssl-cert,ssl-enum-ciphers,ssl-heartbleed,sip-enum-users,sip-brute,sip-methods,rtsp-screenshot,rtsp-url-brute,rpcinfo,vnc-screenshot,x11-access,x11-screenshot,nfs-showmount,nfs-ls,smb-vuln-ms08-067,smb-vuln-ms17-010,smb-ls,smb-enum-shares,http-robots.txt.nse,http-webdav-scan,http-screenshot,http-enum --script-args=http-enum.basepath=200,http-auth --script-args=http-auth.path=/login,http-form-brute,http-sql-injection,http-ntlm-info --script-args=http-ntlm-info.root=/root/,http-git,http-open-redirect,http-vuln-cve2017-5638 --script-args=path=/welcome.action,http-open-proxy,socks-open-proxy,smtp-open-relay,ftp-anon,ftp-bounce,ms-sql-config,ms-sql-info,ms-sql-empty-password,mysql-info,mysql-empty-password,vnc-brute,vnc-screenshot,vmware-version,http-shellshock,http-default-accounts,http-passwd --script-args=http-passwd.root=/test/,smb-vuln-ms17-010,rdp-vuln-ms12-020,vuln,grab_beacon_config,vmware-version,smtp-vuln-cve2020-28017-through-28026-21nails.nse -iL targets.txt -oA /home/kali/Desktop/testing/nmapscans/$NMAP_FILE --stylesheet nmap-bootstrap.xsl && xsltproc -o $NMAP_FILE.html nmap-bootstrap.xsl $NMAP_FILE.xml && ./txt-alert.sh
'
