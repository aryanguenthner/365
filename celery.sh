#!/bin/bash
##############################################
## An asynchronous enumeration & vulnerability scanner
# Run all the tools on all the hosts
# https://sethsec.github.io/celerystalk/
##############################################
cd /opt
git clone https://github.com/sethsec/celerystalk.git
yes | celerystalk/setup/install.sh