#!/bin/python
################################################################################################
# Tested on Kali 2020.1
# Parse Nmap files in ".nmap" format to see a total count
# Parse Nmap files in ".gnmap" format to see total count with the IP Address of the hosts
# Learn More at https://github.com/aryanguenthner
# Example: nmap -iL targets.txt -T4 -sSV --open -vvvv -p 21,22,23 --max-retries 0 -oA nmapscan
# Do this dos2unix *.py* && chmod +x *.py
# Usage: ./nmap-parser.py nmapscan.nmap
# Usage: ./nmap-parser.py nmapscan.gnmap
# Last Updated 2020-03-27
################################################
import sys
import re
import csv

# How to use this nmap parser
print('Usage: ./nmap-parser.py nmapscan.nmap\n')
print('or\n')

# If you don't use it correctly you will have to try again
if len(sys.argv) == 1:
    print ('Usage: ./nmap-parser.py nmapscan.gnmap\n\r')

if len(sys.argv) == 2:
    print ('Parsing Initiated')

#  Takes user supplied scan.nmap file as input
input = sys.argv[1]

print('')
# Open the input file, write results to results.csv.
with open(input, 'r') as rf:
    with open('results.csv', 'w') as wf:
        for line in rf.readlines():

# Uncomment if you want the IP address of the open port.
#            if 'Nmap scan report' in line:
#                wf.write(line)
#                print(line)

            if 'tcp' in line:
                wf.write(line)
                print(line)


print('')
print('Saving to results.csv')
print('')
print('Man that was fast!')
print('')
print('Go Ducks!')
print('')
print('Use The Counter Script To Get A Summary Of The Results: ./counter.sh')
