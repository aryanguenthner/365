#!/bin/bash
# IVRE Dashboard 01/29/2021
# Start IVRE Dashboard
echo
echo "Step 1) ivre scan2db nmapscan.xml"
echo
echo -e '\r'
echo "Step 2) ivre db2view nmap"
echo
echo -e '\r'
echo "Step 3) Open IVRE Dashbaord"
echo
ivre httpd --bind-address 0.0.0.0 --port 9999
echo -e '\r'
