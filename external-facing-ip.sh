#!/bin/bash
################################################
# Identify Your External Facing IP Address
# Tested On Kali 2019.3
# Results are saved in external-ip.txt
# Usage: ./external-facing-ip.sh
# Learn more at https://github.com/aryanguenthner
# Last Updated 10/15/2019
################################################
echo
echo
echo "Writing Your External IP Address To external-ip.txt"
curl -s http://ifconfig.me/ip 2>&1 | tee external-ip.txt
echo
echo
# Best Team Ever!
echo
echo "Go Ducks!"
