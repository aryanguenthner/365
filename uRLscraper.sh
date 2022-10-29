#!/usr/bin/env bash

################################################
# Scrape URLs from a website
# Tested on Kali 2022.4
# If you're reading this pat yourself on the back
# Learn more at https://github.com/aryanguenthner/
# Last Updated 10/28/2022
################################################

echo "
        _____  _         _____  _____ _____            _____  ______ _____  
       |  __ \| |       / ____|/ ____|  __ \     /\   |  __ \|  ____|  __ \ 
  _   _| |__) | |      | (___ | |    | |__) |   /  \  | |__) | |__  | |__) |
 | | | |  _  /| |       \___ \| |    |  _  /   / /\ \ |  ___/|  __| |  _  / 
 | |_| | | \ \| |____   ____) | |____| | \ \  / ____ \| |    | |____| | \ \ 
  \__,_|_|  \_\______| |_____/ \_____|_|  \_\/_/    \_\_|    |______|_|  \_\ "

#wget -4 -qO- https://www.defense.gov/Resources/Military-Departments/DOD-Websites/category/ | grep -Eo (http|https)://[a-zA-Z0-9./?=_-]* | sort -u | tee urls.txt

# Setting Variables
YELLOW=033m
BLUE=034m
KALI=`hostname -I`
SUBNET=`ip r | awk 'NR==2' | awk '{print $1}'`
LS=`ls -l`
PWD=`pwd`
SORT="sort -u"
RANDOM=$$

# Networking
echo ""
echo -e "\e[034mPublic IP Address\e[0m"
curl ifconfig.me
echo
echo
echo -e "\e[034mKali IP Address\e[0m"
echo $KALI
echo

echo -n "Enter the site to extract URLs: "
read URL

# wget magic
wget -4 -qO- $URL -np --trust-server-names --max-redirect=1 --content-disposition --show-progress --no-check-certificate ‐‐user-agent=Mozilla --connect-timeout=4 | grep -Eo '(http|https)://[a-zA-Z0-9./?=_-]*' | $SORT > urls.txt
echo

# Stripper
grep -v '\.\(css\|js\|png\|gif\|jpg\|JPG\|ico\|jpeg\|woff\|woff2\|svg\|wav\|mp4\|mp3\|dtd\|eot\|ttf\)$' urls.txt | tee urlresults.txt

# Get domains
cat urlresults.txt | awk -F/ '{print $3}' | sort -u > url-domains.txt
echo

# Output Files
echo -e "\e[034mResults\e[0m"
echo urlresults.txt
echo url-domains.txt
echo

# Target Site
echo -e "\e[034mTarget\e[0m" $URL
echo

# Count URLS
echo -e "\e[034mTotal URLs Found\e[0m"
wc urlresults.txt | awk '{print $1}'
echo

# Count Domains
echo -e "\e[034mTotal Domains Found\e[0m"
wc url-domains.txt | awk '{print $1}'
echo

# TODO
# Screenshot all the things
# ./gowitness-2.4.2-linux-amd64 file -f urlresults.txt
# Can I get a Witness?
GWIT=gowitness-2.4.2-linux-amd64
if [ -f $GWIT ]
then
    echo "Found gowitness-2.4.2-linux-amd64"

else

    echo -e "\e[034mDownloading Missing $GWIT File\e[0m"
wget -O $PWD/gowitness-2.4.2-linux-amd64 https://github.com/aryanguenthner/gowitness/releases/download/gowitness/gowitness-2.4.2-linux-amd64 > /dev/null/

fi

echo "Getting Screenshots"
echo
./gowitness-2.4.2-linux-amd64 file -f urlresults.txt
echo
# TODO
# Subdomain Enumeration
# amass enum url-domains.txt | tee amass-results.txt
echo "View Report http://localhost:7171"
echo
./gowitness-2.4.2-linux-amd64 server report

