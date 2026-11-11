#!/usr/bin/ksh

 . /etc/profile;

d1=`date +"%d%h%y"`
file=/tmp/custom.log_$d1

# IF log file does not exist, create it
if [ ! -f $file ];
then
         echo "$file does not exist.Creating it"
         `/usr/bin/touch $file`

fi

echo "`/usr/IBM/analytics/ha_tools/hals`" >> $file
echo "`/usr/bin/lsrpnode`" >>  $file
echo "`/usr/bin/lsrpdomain`" >> $file
echo "`/usr/lpp/mmfs/bin/mmgetstate -a`" >> $file


0,5,10,15,20,25,30,35,40,45,50,55 * * * * /usr/local/script/Pdoa_mon.ksh > /dev/null
