#!/usr/bin/bash

input_file=hosts.csv
output_file=hosts_tested.csv

echo "ServerName,IP,PING,DNS,SSH" > $output_file

cat $input_file | grep -v ServerName | while read line
do
   host=$(echo $line | cut -f1 -d',')
   ip=$(echo $line | cut -f2 -d',')

   ping -c 3 $ip > /dev/null
   if [ $? -eq 0 ];then
      ping_status="OK"
    else
      ping_status="FAIL"
   fi

   nslookup $host > /dev/null
   if [ $? -eq 0 ];then
      dns_status="OK"
    else
      dns_status="FAIL"
   fi

   nc -z -w3 $ip 22 > /dev/null
   if [ $? -eq 0 ];then
      ssh_status="OK"
    else
      ssh_status="FAIL"
   fi

   echo "Host = $host IP = $ip" PING_STATUS = $ping_status DNS_STATUS = $dns_status SSH_STATUS = $ssh_status
   echo "$host,$ip,$ping_status,$dns_status,$ssh_status" >> $output_file
done
