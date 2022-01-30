# Setup Text and Email alerts on Kali Linux 2014.4
# Generate Applicaiton Password
# Last updated 01/31/2022
: '
apt update && apt -y upgrade
apt -y install mailutils mpack sstmp
'
# Generate ssmtp Applicaiton Password
: '
https://myaccount.google.com/apppasswords
Choose Other (Custom name), type ssmtp and click Generate.
Copy the generated password and save it.
'
# ssmtp Config
: '
sudo nano -c /etc/ssmtp/ssmtp.conf
# comment everything out everything and keep it in this format.

mailhub=smtp.gmail.com:587
hostname=kali
rewriteDomain=hacked.com
useSTARTTLS=YES
AuthUser=your-gmail-address@gmail.com
AuthPass=TheGeneratedPassword
TLS_CA_File=/etc/pki/tls/certs/ca-bundle.crt
FromLineOverride=YES

'
# Save and close ssmtp.conf
#
: '

mkdir -p /home/kali/Desktop/testing
cd /home/kali/Desktop/testing
nano -c txt-alert.sh

# Enter this in the txt-alert.sh
DATE="$(date +%Y%m%d)"
xfce4-screenshooter -f -c -s $DATE.jpg --no-border
mpack -s "hacked" $DATE.jpg 3105551212@mms.att.net
'
# Save and close txt-alert.sh

# Test it out!!
nmap -sn -n yahoo.com && ./txt-alert.sh
