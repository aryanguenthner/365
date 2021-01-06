#!/bin/bash
# IVRE Dashboard 01/01/2020
# Start IVRE Dashboard
echo
echo
echo "IVRE IP Address"
hostname -I
echo
echo "Step 1) ivre scan2db *.xml"
echo
echo -e '\r'
echo "Step 2) ivre db2view nmap"
echo
echo -e '\r'
echo "Step 3) Open IVRE Dashbaord"
echo
ivre httpd --bind-address 0.0.0.0 --port 9999
echo -e '\r'
