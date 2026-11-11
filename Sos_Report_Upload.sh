# #Script to Collect and upload the SOS Report to dropbox Via ftp

#!/bin/bash

cat /dev/null | tee /tmp/sos_list

Nodes=/tmp/nodes
Sos_list=/tmp/sos_list

echo -n "PLEASE INPUT REDHAT CASE NO :";
read Caseno


Str1=/tmp/
Str2="sosreport*";
Src_Dir="$Str1$Str2";

Str3=/data/
Dest_Dir="$Str3$Caseno"

if [ ! -d "$Dest_Dir" ];
then

        echo -e "$Dest_Dir DIRECTORY DOESNOT EXISTS \n";
        echo "CREATING THE DIRECTORY WITH CASE NO: WHERE ALL SOS LOGS WILL BE GATHERED........... $Dest_Dir";
       ` /bin/mkdir -p "$Dest_Dir" `
fi

/opt/VRTS/bin/vxclustadm nidmap | egrep -v "Out of Cluster|Name" | /bin/awk '{print $1}' > $Nodes

echo -e "Below SOS logs  will be copied to Master Node\n";

for i in `cat $Nodes`; do ssh -q $i "ls -1tc $Src_Dir | grep -v "md5" "; done

########## Copy SOS logs to Master ####################

for j in `cat $Nodes`
do
 scp $j:$Src_Dir $Dest_Dir;

done
