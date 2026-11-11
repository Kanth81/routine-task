#!/bin/ksh

##################################################################
# DISK UTLIZATION 

THRESHOLD_DISK=70
THRESHOLD_CPU=0.3

disklog=/tmp/disklog
disklog1=/tmp/disklog1
ebody=/tmp/ebody

df -g | awk '{print $1,$4}' | sed 's/.$//' > $disklog
grep "/dev" $disklog > $disklog1


# set the Internal Field Separator to a pipe symbol
IFS=" "

echo "1)DISK UTILIZATION\n
Please be aware that the following disks usage have crossed the threshold value ${THRESHOLD_DISK}%  on host $(hostname)." >$ebody
echo "List of Disks	        Used%" >>$ebody

# use while loop to read disk information and %used
while read disk use
do

        if [ $use -gt ${THRESHOLD_DISK} ]
        then

		 printf "%s\t%3d\n" "$disk" "$use">> $ebody

        fi

done < $disklog1

#If there is more than 4 row in file $ebody, then skip. Else, echo "All disks are below threshold usage  of ${THRESHOLD_DISK} percent"

       lcount="$(wc -l < $ebody)"
	if [ $lcount -le 4 ]; 
	then
		echo "1)DISK UTILIZATION
			All disks usage are below threshold ${THRESHOLD_DISK}%" >$ebody
	fi

	if [ $lcount -gt 4 ];
	then

		echo "\nNext course of Action : 
	1 - Please login and verify if the disk usage is genuine. If yes, please raise work order for increase in space 
	2 - If the disk usage is not genuine, please purge old logs or unwanted files." >>$ebody


	fi


#########################################################################
# %CPU UTLIZATION

cpulog=/tmp/cpulog
cpulog1=/tmp/cpulog1
ps -efo pcpu,pid,ppid,user,tty,command > $cpulog
 echo "$(tail -n +2 $cpulog)" >$cpulog1


IFS=" "


echo "\n2)CPU UTILIZATION\n
Please be aware that the following processes have reached or crossed the threshold value  ${THRESHOLD_CPU}% on host $(hostname)." >> $ebody
print "%CPU\t   PID\t\t  PPID\t\t   USER\t\t TTY\t\t  COMMAND" >>$ebody


while read cpu_per pid ppid user tty  command
do

        if (( ${cpu_per##*.} >= ${THRESHOLD_CPU##*.} ))
        then

                print "$cpu_per\t $pid\t $ppid\t $user\t $tty\t $command" >>$ebody
        fi


done < $cpulog1

echo "\n Next course of Action :
Please kill the UNWANTED process to release the Cpu Usage or Contact application support team for clarification on cpu usage." >> $ebody



########################################################################
# DB2 diag path DDV01SBC

dgpath=/tmp/path.log
db2 get dbm cfg | grep -i diagpath | head -1 > $dgpath

path="$(cut -f 2 -d "= " $dgpath)"
dblog=${path}db2diag.log

echo "\n3)DB2 DIAGNOTSTIC LOGS" >> $ebody
echo "\nTotal No of Severe: `grep -c 'LEVEL: Severe' $dblog`" >> $ebody
awk  '/LEVEL: Severe/{x=NR+7} (NR <=x){print}' $dblog >>$ebody

echo "\nTotal No of Error: `grep -c 'LEVEL: Error' $dblog`" >>$ebody
awk  '/LEVEL: Error/{x=NR+7} (NR <=x){print}' $dblog >>$ebody



#######################################################################
# Long Running Utility

lru=/tmp/lru.log
echo "\n4)LONG RUNNING UTILITY" >>$ebody
 db2 list utilities show detail > $lru
if ( grep -q  "BACKUP" $lru );then
        echo "\n Warning, Backup is a Long Running Utility" >>$ebody
        `cat $lru` >>$ebody
else

        print "Currently there are no long Running Utility.">>$ebody
fi


#*******************************************
# Latest Database bacup TimeStamp

dbt1log=/tmp/dbt1.log
dbt2log=/tmp/dbt2.log
dbt3log=/tmp/dbt3.log
dbt4log=/tmp/dbt4.log

print "\n5)LATEST DATABASE BACKUP TIMESTAMP">>$ebody

 `ls -lt /backups/${DB2INSTANCE}/*/*` > $dbt1log

   if (($? > 0)) 
then
	print "There are no database backup">>$ebody 
else

awk '/total/{getline;print;}' $dbt1log > $dbt2log
sed  '/^$/d' $dbt2log > $dbt3log
awk '{print $NF}' $dbt3log > $dbt4log
print "DATABASE         TIMESTAMP\n">>$ebody
awk -F "."  '{printf ("%10s\t%d\n", $1,$(NF-1))}' $dbt4log >>$ebody 

fi
########################################################################
# TABLESPACE STATE

tslog1=/tmp/tablespace1.log
tslog2=/tmp/tablespace2.log
tslog3=/tmp/tablespace3.log
tslog4=/tmp/tablespace4.log
tslog5=/tmp/tablespace5.log

DBNAME_LIST=$1
if [[ -z $DBNAME_LIST ]];then
   echo "Pass the Database Names as file Parameter to the script" >&2
   exit 1
fi


i=1;
while read dbname
do

if [[ -z $dbname  ]];then
   echo "Pass the Database Name as Parameter to the script" >&2
   exit 1
fi

#print "\n" $i.$dbname  >> $ebody
echo "\n6)TABLESPACE STATE  FOR DATABASE $dbname on host `hostname`" >>$ebody 

db2 +t  connect to $dbname >&2
((i = i + 1))

if (($? == 0))
then


db2 list tablespaces > $tslog1
awk '/Name/{x=NR+3} (NR<=x) {print}' $tslog1 > $tslog2
grep -v "Type" $tslog2 > $tslog3
grep -v "Contents" $tslog3 > $tslog4
echo "`cut -f 2 -d '=' $tslog4`" > $tslog5


print "\nTableSpace NAME\t\t  STATE" >>$ebody
 while read tsname;
do
 read state;
 printf "%16s\t %6s\n" $tsname  $state >> $ebody
done < $tslog5

while read tsname;
do
read state;
if [[ $state != 0x0000 ]];then 

  echo "\nWarning: Tabel Space $tsname is not in Normal state.Please check the logs at $tslog5 for more information.">>$ebody

fi
done < $tslog5



#######################################################################
# CHECK LOCKS

dbver=/tmp/dbver.log
locklog=/tmp/lock.log

db2level > ${dbver}

print "\n7)CHECK LOCKS for $dbname" >>$ebody
ver=`tail -2 ${dbver} | cut -c 40-43`
thr_ver=9.7

if  (( ${ver%.*} > ${thr_ver%.*} || ${ver#*.} > ${thr_ver#*.} ))
then
db2 -r $locklog "select TABSCHEMA,TABNAME, LOCK_OBJECT_TYPE,LOCK_WAIT_ELAPSED_TIME, REQ_USERID, REQ_APPLICATION_NAME,HLD_USERID, HLD_APPLICATION_NAME from sysibmadm.mon_lockwaits"
        
	if ( grep -q '0 record' $locklog )then
                print "Table is not Locked" >>$ebody

	else
		print `cat $locklog` >>$ebody
        fi


else
db2 -r $locklog "select substr(ltrim(char(ai_h.AGENT_ID)),1,10) as "Holder_AgentID",lw.APPL_ID_HOLDING_LK as "Holder_Appid",substr(ai_h.APPL_NAME,1,10) as "App_Holding_lock",substr(ai_h.PRIMARY_AUTH_ID,1,10) as "Holder",ai_w.AGENT_ID as "Waiter_AgentID",substr(ai_w.APPL_NAME,1,10) as "App_Waiting_on_Lock",substr(ai_w.PRIMARY_AUTH_ID,1,10) as "Waiter",lw.LOCK_MODE as "Hold_Mode",lw.LOCK_OBJECT_TYPE as "ObjType",substr(lw.TABNAME,1,25) as "table",substr(lw.TABSCHEMA,1,10) as "schema",timestampdiff(2,char(lw.SNAPSHOT_TIMESTAMP - lw.LOCK_WAIT_START_TIME)) as "Waiting" from sysibmadm.snapappl_info ai_h,sysibmadm.snapappl_info ai_w,sysibmadm.snaplockwait lw where lw.agent_id = ai_w.AGENT_ID and lw.APPL_ID_HOLDING_LK = ai_h.AGENT_ID";

        if ( grep -q '0 record' $locklog )then
                print "Table is not Locked" >>$ebody

	else
		print `cat $locklog` >>$ebody
        fi


fi

###############################################################################
#RUNSTATS

print "\n8)RUNSTATS for $dbname">>$ebody
statlog=/tmp/stat.log
`rm $statlog`
db2 -r $statlog "select TABSCHEMA,substr(tabname,1,30),stats_time from syscat.tables where date(stats_time) < CURRENT DATE -16 days"
if ( grep -q '0 record' $statlog )then
    print "Warning: Runstats are updated earlier than two weeks">>$ebody

else
	print `cat $statlog` >>$ebody
fi


 db2 +t  connect reset;


else
	print "Failed to connect to database"

fi

done < "$DBNAME_LIST"

#*******************************************


 print "*********************** END OF REPORT**************************">>$ebody

mail -s "DB2 Health Check Report on host `hostname`"  lakshmikanthtn@gmail.com < $ebody


