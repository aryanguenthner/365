#!/usr/bin/env bash

################################################
# Scrape URLs from a website
# Tested on Kali 2022.4
# If you're reading this pat yourself on the back
# Learn more at https://github.com/aryanguenthner/
# Last Updated 10/25/2022
################################################

# wget -qO- -np --trust-server-names --max-redirect=1 --content-disposition --show-progress --no-check-certificate ‐‐user-agent=iPhone --connect-timeout=4 -4 --reject=gif,js,ico,jpg,jpeg,png,css,woff,woof2,svg https://yahoo.com/ | grep -Eo (http|https)://[a-zA-Z0-9./?=_-]* | sort -u | tee example.txt
#

echo
# Setting Variables
YELLOW=033m
BLUE=034m
KALI=`hostname -I`
SUBNET=`ip r | awk 'NR==2' | awk '{print $1}'`
LS=`ls -l`
PWD=`pwd`
WGET="wget -qO- -np --trust-server-names --max-redirect=1 --content-disposition --show-progress --no-check-certificate ‐‐user-agent=iPhone --connect-timeout=4"
GREP="grep -Eo (http|https)://[a-zA-Z0-9./?=_-]*"
#GREP2="grep -v '\.\(css\|js\|png\|gif\|jpg\|ico\|jpeg\|woff\|woff2\|svg\|wav\|mp4\|mp3\|dtd\|eot\|ttf\)$'"
SORT="sort -u"
DOM="-D"
echo

# Networking
echo ""
echo -e "\e[034mPublic IP Address\e[0m"
curl ifconfig.me
echo
echo
echo -e "\e[034mKali IP Address\e[0m"
echo $KALI
echo

# Your directory
echo -e "\e[034mCurrent Directory\e[0m"
echo $PWD
echo

# Working Directory
cd /home/kali/Desktop/testing/webapp-testing

# Extract URLs from a web site
# Get URLs from Target Site
echo -e "\e[034mExample: irongeek.com\e[0m"
echo
echo -en "\e[034mTarget Site Domain?\e[0m: "
read URL
echo

echo -e "\e[034mKeep Calm\e[0m"
# Get URLS filter out file types
$WGET $URL | $GREP | $SORT > $URL+urls.txt
grep -v '\.\(css\|js\|png\|gif\|jpg\|ico\|jpeg\|woff\|woff2\|svg\|wav\|mp4\|mp3\|dtd\|eot\|ttf\)$' $URL+urls.txt > $URL+results.txt

# Remove protocol http,https,www from domains
cat $URL+results.txt | sed -e 's/^http:\/\///g' -e 's/^https:\/\///g' -e 's/^www.//g' | tee $URL+no-prefix.txt
echo

# Output Files
echo -e "\e[034mResults\e[0m"
echo $URL+results.txt
echo $URL+no-prefix.txt
echo

# Count URLS
echo -e "\e[034mTotal URLs\e[0m"
wc $URL+results.txt | awk '{print $1}'


# https://www.defense.gov/Resources/Military-Departments/A-Z-List/
