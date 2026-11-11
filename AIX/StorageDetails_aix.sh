#!/bin/sh

# TO FIND THE ALLOCATED  STORAGE(GB) ON SERVER


cat /dev/null | tee /tmp/salog  /tmp/sflog;
for i in `lspv | awk '{print $1}'`; do lspv $i | grep -i "TOTAL PPs" ; done >> /tmp/salog;
echo "Allocated Storage";
awk -F ' ' '$1 == "TOTAL" {sum += $3}  END {print sum}' /tmp/salog;

# TO FIND THE FREE STORAGE(GB) ON SERVER
 for i in `lspv | awk '{print $1}'`; do lspv $i | grep -i "FREE PPs" ; done >> /tmp/sflog
  echo "Free Storage"
  awk -F ' ' '$1 == "FREE" {sum += $3}  END {print sum}' /tmp/sflog
