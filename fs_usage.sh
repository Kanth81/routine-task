#!/bin/bash

cat /dev/null | tee /tmp/FS_Det.log | tee /tmp/FS_Det.csv

for i in `cat servers`

do ssh -q $i "hostname | cut -f 1 -d '.'; df -khP" >> /tmp/FS_Det.log

done

 awk '{printf("%s,%s,%s,%s\n",$1,$2,$3,$5) }' /tmp/FS_Det.log > /tmp/FS_Det.csv
( cd /tmp; (uuencode FS_Det.csv FS_Det.csv)| mailx -s "Filesystem Utilisation for DIME3" -r "lakshmikanth.talkadnagaraju"  lakshmikanthtn@gmail.com )



df -kP > /tmp/FS_Det.log
awk '{printf("%s,%s,%s,%s\n",$1,$2,$3,$5) }' /tmp/FS_Det.log > /tmp/FS_Det.csv
