#!/bin/bash
##############################################
# Tested on Kali 2020.1
# Learn more https://github.com/aryanguenthner
# Hack to Learn and Learn to Hack
# Last Updated 04/26/2020
##############################################
YELLOW='033m'
echo -e "\e[033mVM IP\e[0m"
VM=`hostname -i`
echo "Step 1) ivre scan2db somenmapfile.xml"
echo
echo "Step 2) ivre db2view nmap"
echo
echo "Step 3) Access the IVRE Dashboard"
echo $VM
ivre httpd --bind-address 0.0.0.0 --port 8888 &
echo "Press Enter"
echo "IVRE Now Running as a Process"
