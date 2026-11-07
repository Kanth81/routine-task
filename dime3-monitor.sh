#!/bin/bash

#Created By : Lakshmikanth
#Created on : 2nd-July-2016
#Description: This script check the system load averages for past 15 mins on DIME3 environment, for a threshold value of 60 and alters
#the user via email.

TOTAL_NODES=25
Nodename=/tmp/nodename.log
output1=/tmp/output1.log
output2=/tmp/output2.log
syscount=/tmp/syscount
ebody=/tmp/ebody
output3=/tmp/output3.log
output4=/tmp/output4.log
THRESHOLD=60

/opt/VRTS/bin/vxclustadm nidmap | awk '{print $1}' | grep -v 'Name' > $Nodename

cat /dev/null | tee /tmp/output1.log /tmp/output2.log /tmp/output3.log  /tmp/output4.log  /tmp/ebody


/opt/VRTS/bin/hastatus -sum |grep ^A | grep -c 'RUNNING' > $syscount
if test  `cat $syscount` -ne  $TOTAL_NODES
then
        echo -e "\nCLUSTER STATUS\n" > $ebody
        echo -e "Few nodes are not in Running State\n" >> $ebody
fi


for i in `cat $Nodename`
 do
        ssh -q $i "hostname | cut -f 1 -d '.';uptime | grep -ohe 'load average[s:][: ].*' |awk '{ print }' | cut -c15-34" >> $output1
 done


# 15 mins load avg
cat $output1 | cut -d',' -f 3 | cut -d'.' -f 1 | sed 's/ //g'  > $output2

while read node;
 do
        read loadavg;
        echo "$node $loadavg" >> $output3

 done < $output2

echo -e "\nPLEASE FIND BELOW NODE/S WHICH HAS BREACHED THE THRESHOLD VALUE $THRESHOLD\n" >> $ebody

# NODES WHICH CROSSED THRESHOLD VALUE

awk '{if ($2 > '$THRESHOLD' ) print $1 }' $output3 |tee $output4 -a $ebody


echo -e "\n TOP OUTPUT FOR NODES WHICH BREACHED THRESHOLD VALUE $THRESHOLD\n" >> $ebody

if test `cat $output4 | wc -l` -gt 0
then

        for i in `cat $output4`
        do ssh -q $i  "hostname | cut -f 1 -d '.';echo ;top -b -n 1 | head -n 50;echo ;"; done >> $ebody

echo -e "*********************** END OF REPORT**************************">>$ebody

mailx -s "DIME3 PROD  HIGH LOAD AVERAGE WITH THRESHOLD VALUE > $THRESHOLD" -r "Lakshmikanth" DL.PSO.Infy.IE.Linux@SunTrust.com < $ebody

fi
