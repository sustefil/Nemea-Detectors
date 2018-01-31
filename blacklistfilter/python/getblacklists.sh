#!/bin/bash

curl https://www.spamhaus.org/drop/edrop.txt | sed 's/\s*;.*$//;' > spamhaus-org-edrop.txt

curl https://lists.blocklist.de/lists/ssh.txt > blocklist-de-ssh.txt

curl https://ransomwaretracker.abuse.ch/downloads/RW_IPBL.txt |grep -v '^#' > abuse-ch-ransomware.txt

