#!/usr/bin/env bash

################################################
# Reconnaissance Tool used to scrape URLs from a website
# Open http://localhost:7171 to view the Gowitness report
# Tested on Kali 2022.4
# If you're reading this pat yourself on the back
# Learn more at https://github.com/aryanguenthner/
# credit: https://github.com/sensepost/gowitness/releases
# Last Updated 11/5/2022
################################################
echo "
██╗░░░██╗██████╗░██╗░░░░░░██╗░░░░░░░██╗██╗████████╗███╗░░██╗███████╗░██████╗░██████╗
██║░░░██║██╔══██╗██║░░░░░░██║░░██╗░░██║██║╚══██╔══╝████╗░██║██╔════╝██╔════╝██╔════╝
██║░░░██║██████╔╝██║░░░░░░╚██╗████╗██╔╝██║░░░██║░░░██╔██╗██║█████╗░░╚█████╗░╚█████╗░
██║░░░██║██╔══██╗██║░░░░░░░████╔═████║░██║░░░██║░░░██║╚████║██╔══╝░░░╚═══██╗░╚═══██╗
╚██████╔╝██║░░██║███████╗░░╚██╔╝░╚██╔╝░██║░░░██║░░░██║░╚███║███████╗██████╔╝██████╔╝
░╚═════╝░╚═╝░░╚═╝╚══════╝░░░╚═╝░░░╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░╚══╝╚══════╝╚═════╝░╚═════╝░"

echo
# wget -4 -qO- https://www.defense.gov/Resources/Military-Departments/DOD-Websites/category/ | grep -Eo (http|https)://[a-zA-Z0-9./?=_-]* | sort -u | tee url-results.txt
# Remove http,https,www
# cat url-results.txt | sed -e 's/^http:\/\///g' -e 's/^https:\/\///g' -e 's/^www.//g' | tee dod-domains.txt

# Setting Variables
YELLOW=033m
BLUE=034m
KALI=`hostname -I`
SUBNET=`ip r | awk 'NR==2' | awk '{print $1}'`
LS=`ls -l`
PWD=`pwd`
SORT="sort -u"
RANDOM=$$
echo

# Stay Organized
mkdir -p /home/kali/Desktop/testing/urlwitness/
cd /home/kali/Desktop/testing/urlwitness/
chmod -R 777 /home/kali/

# Todays Date
echo -e "\e[034mToday is\e[0m"
date
echo

# Working Directory
echo -e "\e[034mCurrent Directory\e[0m"
echo $PWD
echo

# Networking
echo -e "\e[034mPublic IP Address\e[0m"
curl ifconfig.me
echo

echo -e "\e[034mKali IP Address\e[0m"
echo $KALI
echo

# Check yo shit
echo -e "\e[034mRequirements Check\e[0m"
# Google browser download if needed
echo
GOOG=/opt/google/chrome/google-chrome
if [ -f $GOOG ]
then
  echo "Found Google Chrome"
    
else
  echo "Downloading Google Chrome Stable Browser"
cd /tmp
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb

fi
echo

# Can I get a Witness?
GWIT=gowitness-2.4.2-linux-amd64
if [ -f $GWIT ]
then
  echo "Found Gowitness"

else
  echo -e "\e[034mDownloading Missing $GWIT File\e[0m"
wget -O $PWD/gowitness-2.4.2-linux-amd64 https://github.com/aryanguenthner/gowitness/releases/download/gowitness/gowitness-2.4.2-linux-amd64

fi
echo

# Start urlwitness
cd /home/kali/Desktop/testing/urlwitness
echo -en "\e[034mEnter the site to scrape URLs:\e[0m"
read URL
echo

# wget magic
wget -4 -qO- --referer=$URL $URL --random-wait --trust-server-names --show-progress --no-check-certificate ‐‐user-agent=Mozilla --connect-timeout=4 | grep -Eo '(http|https)://[a-zA-Z0-9./?=_-]*' | $SORT > urls.txt
echo

# Strippers
grep -v '\.\(css\|js\|png\|gif\|jpg\|JPG\|ico\|jpeg\|woff\|woff2\|svg\|wav\|mp4\|mp3\|dtd\|eot\|ttf\|webp\)$' urls.txt | tee url-results.txt
sed -i '/s.yimg/d' url-results.txt

# Get domains
cat url-results.txt | awk -F/ '{print $3}' | tee url-domains1.txt
cat url-domains1.txt | sed -e 's/^http:\/\///g' -e 's/^https:\/\///g' -e 's/^www.//g' | tee domains1.txt
awk '!/^[[:space:]]*$/' url-domains1.txt | sort -u > url-domains.txt
awk '!/^[[:space:]]*$/' domains1.txt | sort -u > domains.txt
rm url-domains1.txt domains1.txt
echo

# Output Files
echo -e "\e[034mResults\e[0m"
echo url-results.txt
echo url-domains.txt
echo domains.txt
echo urls.txt
echo

# Target Site
echo -e "\e[034mTarget\e[0m"
echo $URL
echo

# Count URLS
echo -e "\e[034mTotal URLs Found\e[0m"
wc url-results.txt | awk '{print $1}'
echo

# Count Domains
echo -e "\e[034mTotal Domains Found\e[0m"
wc url-domains.txt | awk '{print $1}'
echo

# Get Screenshots
echo "Getting Screenshots"
echo
chmod -R 777 /home/kali/
./gowitness-2.4.2-linux-amd64 file -f url-results.txt
echo
echo  -e "\033[33;5mReport Finished http://localhost:7171\033[0m"
echo
./gowitness-2.4.2-linux-amd64 server report
echo

# May the force be with you!

