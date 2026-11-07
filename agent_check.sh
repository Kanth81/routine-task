##########################################

## To stop/start agents across nodes which will speed up the cluster recovery time.
#Author : Lakshmikanth
###########################################


#!/bin/bash

Nodes=/tmp/nodes

/opt/VRTS/bin/hasys -list  > $Nodes



# Check the stop status of the agents across all nodes.
#########################################################


action=$1;

if [ -z $action  ];then
        echo "one of the argument should be passed to script as stop/start/stopstatus/startstatus"
        exit 1
 fi


if [ $action == stopstatus ]
then


for i in `cat $Nodes`
do

        cat /dev/null | tee  /tmp/agstopstatus_$i

        echo "`date` SERVER: $i" >  /tmp/agstopstatus_$i



        for j in "service auditd status" "/usr/openv/netbackup/bin/bpps -a" "service splunk status" "service crond status" "service zabbix-agent status" "/opt/VRTSsfmh/adm/xprtldctrl status" "/opt/VRTSsfmh/adm/vxvmdiscovery-ctrl.sh status" "/opt/VRTSsfmh/etc/vxdcli.sh status"
        do
                ssh -q $i "$j" >> /tmp/agstopstatus_$i 2>&1;

        done


        SP_COUNT=`grep -ic 'stopped' /tmp/agstopstatus_$i`;
        NOT_RUNNING=`grep -c "not running" /tmp/agstopstatus_$i`;
        NB=`grep -ic "\-standalone" /tmp/agstopstatus_$i`;
	

        if [[ $SP_COUNT == 5 && $NOT_RUNNING == 2 && $NB == 0 ]];then
                echo -e "All Agents & Vom Services are Stopped on $i\n";

        else
                echo -e "One or more agents have failed to stop on $i."
                echo -e "Please check the logs at /tmp/agstopstatus_$i"

        fi


done

# Check the start status of the agents across all nodes.
#########################################################


elif [ $action == startstatus ]
then


for x in `cat $Nodes`
do

        cat /dev/null | tee /tmp/agstartstatus_$x

        echo "`date` SERVER: $x" > /tmp/agstartstatus_$x



        for y in "service auditd status" "/usr/openv/netbackup/bin/bpps -a" "service splunk status" "service crond status" "service zabbix-agent status" "/opt/VRTSsfmh/adm/xprtldctrl status" "/opt/VRTSsfmh/adm/vxvmdiscovery-ctrl.sh status" "/opt/VRTSsfmh/etc/vxdcli.sh status"
        do
                ssh -q $x "$y" >>  /tmp/agstartstatus_$x 2>&1;

        done



       ST_COUNT=`grep -i "running" /tmp/agstartstatus_$x |  grep -v "process" |wc -l`;
        NB=`grep "\-standalone" /tmp/agstartstatus_$x | wc -l`;

	#echo "$ST_COUNT";
	#echo "$NB";
        if [[ $ST_COUNT == 8 && $NB == 2 ]];then
        echo -e "All agents & Vom services are started on $x\n";

        else
        echo -e "One or more agents have failed to start on $x."
        echo -e "Please check the logs at /tmp/agstartstatus_$x "

        fi

done


# Start the Agents  & VOM services across all nodes.
#########################################################



elif [ $action == start ]
then

# To start agents and vom services across all nodes

for k in `cat $Nodes`
do
        cat /dev/null | tee /tmp/agstart_$k

        echo "`date` SERVER: $k" > /tmp/agstart_$k
		echo -e "Starting Agents & Vom Services on $k \n";
        for m in "service auditd start" "chkconfig auditd on" "service netbackup start" "chkconfig netbackup on" "service splunk start" "chkconfig splunk on" "service crond start" "chkconfig crond on" "service zabbix-agent start" "chkconfig zabbix-agent on" "service ITMAgents1 start" "chkconfig ITMAgents1 on" "/opt/VRTSsfmh/adm/xprtldctrl start" "/opt/VRTSsfmh/adm/vxvmdiscovery-ctrl.sh start" "/opt/VRTSsfmh/etc/vxdcli.sh start"
        do
				
                ssh -q $k "$m" >> /tmp/agstart_$k 2>&1;
        done
	
done


# Stop the Agents and VOM services across all nodes
#######################################################

elif [ $action == stop ]
then


for n in `cat $Nodes`
do
        cat /dev/null | tee /tmp/agstop_$n

        echo "`date` SERVER: $n" > /tmp/agstop_$n

        for k in "service auditd stop" "chkconfig auditd off" "service netbackup stop" "chkconfig netbackup off" "service splunk stop" "chkconfig splunk off" "service crond stop" "chkconfig crond off" "service zabbix-agent stop" "chkconfig zabbix-agent off"  "service ITMAgents1 stop" "chkconfig ITMAgents1 off" "/opt/VRTSsfmh/adm/xprtldctrl stop"  "/opt/VRTSsfmh/adm/vxvmdiscovery-ctrl.sh stop" "/opt/VRTSsfmh/etc/vxdcli.sh stop"
        do
				echo -e "Stopping Agents & Vom Services on $n \n";
                ssh -q $n "$k"  >> /tmp/agstop_$n  2>&1;
        done

done

fi


