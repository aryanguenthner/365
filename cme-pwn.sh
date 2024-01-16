#!/usr/bin/env bash

# Tested on Kali 2023.4
# Updated 01/15/2024
# Hack The Planet

# Setting Variables

KALI=$(hostname -I)
SUBNET=$(ip r | awk 'FNR == 2 {print $1}')
TARGETS=ips.txt
PWD=$(pwd)
DATE0=$(date +%Y%m%d).cme_$RANDOM
echo
# How to hack the planet

echo "Usage ./cme-full-scan.sh 10.9.9.0/24"
echo "      ./cme-full-scan.sh subnets.txt"
echo "      ./cme-full-scan.sh ips.txt"
echo
echo "Press Enter for Scan Completion Status"
echo
echo "CTRL+c to start over"
echo
echo "Current Networking Information"
echo
ip r
echo
# Creds

echo -e "Using Creds y/n: "
read CREDS
if [ $CREDS == y ]
then
    # Username
    echo -en "Enter username: "
    read -e USERNAME
    echo

    # Password
    echo -en "Enter password: "
    read -e PASS
    echo

else
    echo
    echo "Running Crackmap without creds"
    echo
    echo
fi
echo

# File name

echo -en "Output File Name: "
read -e FNAME
echo

# User Input

FILE1="$1"
if [ -f $FILE1 ]
then

    echo "Starting Crackmap"
    echo
else
    echo "Missing Input file"

fi
echo

# Crackmap Magic

echo
echo "RDP"
crackmapexec rdp $FILE1 | tee crackmap-rdp-$FNAME.$DATE0.txt;
echo
echo "Exporting RDP targets to rdp-ips.txt"
awk '{print $2}' crackmap-rdp-$FNAME.$DATE0.txt > rdp-ips.txt
echo
echo "WINRM"
crackmapexec winrm $FILE1 | tee crackmap-winrm-$FNAME.$DATE0.txt;
echo
echo "Exporting WinRM targets to winrm-ips.txt"
awk '{print $2}' crackmap-winrm-$FNAME.$DATE0.txt > winrm-ips.txt
echo
echo "LDAP"
crackmapexec ldap $FILE1 | tee crackmap-ldap-$FNAME.$DATE0.txt;
echo
echo "Exporting LDAP targets to winrm-ips.txt"
awk '{print $2}' crackmap-ldap-$FNAME.$DATE0.txt > ldap-ips.txt
echo
echo "MSSQL"
crackmapexec mssql $FILE1 | tee crackmap-mssql-$FNAME.$DATE0.txt;
echo
echo "Exporting MSSQL targets to mssql-ips.txt"
awk '{print $2}' crackmap-mssql-$FNAME.$DATE0.txt > mssql-ips.txt
echo
echo "SMB"
crackmapexec smb $FILE1 | tee crackmap-smb-$FNAME.$DATE0.txt;
echo
echo "Exporting SMB targets to smb-ips.txt"
awk '{print $2}' crackmap-smb-$FNAME.$DATE0.txt > smb-ips.txt
echo
echo "FTP"
crackmapexec ftp $FILE1 | tee crackmap-ftp-$FNAME.$DATE0.txt;
echo
echo "Exporting FTP targets to ftp-ips.txt"
awk '{print $2}' crackmap-ftp-$FNAME.$DATE0.txt > ftp-ips.txt
echo
echo "SSH"
crackmapexec ssh $FILE1 | tee crackmap-ssh-$FNAME.$DATE0.txt;
echo
echo "Exporting SSH targets to ssh-ips.txt"
awk '{print $2}' crackmap-ssh-$FNAME.$DATE0.txt > ssh-ips.txt
echo
echo
echo "Crackmap Finished Results are Ready"
echo
# hack the planet



