#!/bin/bash

Sysdet1=/tmp/sysdet1.log
Sysdet2=/tmp/sysdet2.log
Sysdet3=/tmp/sysdet3.log
Sysdet4=/tmp/sysdet4.log
Sysdet5=/tmp/sysdet5.log
THRESHOLD=30

cat /dev/null | tee /tmp/sysdet1.log /tmp/sysdet2.log  /tmp/sysdet3.log  /tmp/sysdet4.log  /tmp/sysdet5.log

for i in `cat servers`
do
	ssh -q $i "hostname | cut -f 1 -d '.';uptime | cut -f 4 -d ' '" >> $Sysdet1
done

while read node;
do
	read sysup;
	echo -e "$node $sysup" >> $Sysdet2
done < $Sysdet1

# Remove the servers uptime in hours.
grep -iv ':' $Sysdet2 >  $Sysdet3

sort -t"," -k2n,2 $Sysdet3 > $Sysdet4

awk '{if ($2 > '$THRESHOLD' ) printf("%s\t%s\n",$1,$2) }' $Sysdet4  > $Sysdet5

mailx -s "SERVERS WITH UPTIME > $THRESHOLD" lakshmikanthtn@gmail.com < $Sysdet5
