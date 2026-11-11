# Author : Lakshmikanth
# Script to cleanup /VAR space

#!/bin/bash


Nodes=/tmp/nodes

var_cleanup() {


Grep=/bin/grep
Ls=/bin/ls
Awk=/bin/awk
Gzip=/bin/gzip


Sa_Sar_list=/tmp/salist.log
Sa_Sar_Zipped=/tmp/salistnew.log
Src_Dir=/var/log/sa


Str1="/data/sa/"
Str2=$(date "+%b");

Dest_Dir="$Str1$Str2"

cat /dev/null | tee  $Sa_Sar_list $Sa_Sar_Zipped

if [ ! -d "$Dest_Dir" ];
then

        echo "$Dest_Dir DIRECTORY DOESNOT EXISTS \n";
        echo " CREATING THE DIRECTORY........... $Dest_Dir";
       ` /bin/mkdir -p "$Dest_Dir" `
fi



if [ -d "$Dest_Dir" ];
then


        d1=$(date "+%b %__d")

                echo "`$Ls -lrth $Src_Dir | $Grep -i ^- | $Grep -v "$d1" | $Grep -v '\.bz2' | $Grep -v '\.gz' | $Awk '{print $9}' ` " > $Sa_Sar_list

        for i in `cat $Sa_Sar_list`;
        do
            echo "Zipping the file in ******* $Src_Dir/$i *******";
            echo " `gzip -9 $Src_Dir/$i ` " ;
        done

        echo "`$Ls -lrth $Src_Dir | $Grep -i ^- | $Grep -v "$d1" | $Awk '{print $9}' ` " > $Sa_Sar_Zipped

        for i in `cat  $Sa_Sar_Zipped`;
        do
            echo "Moving the Zipped file $Src_Dir/$i to $Dest_Dir/$i"
            `mv $Src_Dir/$i $Dest_Dir/$i`
        done

fi

}
