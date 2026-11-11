#!/bin/sh
=== SCRIPT TO DETECT defunct and ZOMBIE PROCESS

TestZom=`ps -ef | grep 'Z' | grep -iv 'grep' | wc -l`
TestDef=`ps -ef | grep -i 'defunct' | grep -iv 'grep' | wc -l`

ps -ef | grep 'Z' | grep -iv 'grep' > /tmp/zom.txt
ps -ef | grep -i 'defunct' | grep -iv 'grep' > /tmp/def.txt

Outputfilez=`cat /tmp/zom.txt`
Outputfiled=`cat /tmp/def.txt`

if [ $TestZom -gt 0 ];
then
echo -e "Please check the below zombie processes. \n\n $Outputfilez" | mailx -s "ALERT - ZOMBIE PROCESS on  `hostname`" lakshmikanthtn@gmail.com
fi

if [ $TestDef -gt 0 ];
then
echo -e "Please check the below Defunct process. \n\n $Outputfiled" | mailx -s "ALERT - DEFUNCT PROCESS on `hostname`" lakshmikanthtn@gmail.com
fi

