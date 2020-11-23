#!/bin/bash
# IVRE Dashboard 11/20/2020
# Start IVRE Dashboard
IP=`hostname -I`
PORT=8888
echo
echo "IVRE IP Address" $IP
echo
echo "Step 1) ivre scan2db *.xml"
echo
echo -e '\r'
echo "Step 2) ivre db2view nmap"
echo
echo -e '\r'
echo "Step 3) Open IVRE Dashbaord"
#TODO escape ":" so there isn't a break in the dashboard url
echo "http://$IP:$PORT"
echo
ivre httpd --bind-address 0.0.0.0 --port $PORT
echo -e '\r'
