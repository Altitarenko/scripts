#!/bin/bash

file=spisok_linux
log=logping.txt
while IFS='' read -r line || [ "$line" ] ; do
#while read -r line;  do 
        echo "Ping to $line" | tee -a $log 
	ping -c 2 $line | tee -a $log 
	if [[ $? -eq 0 ]] ; 
        	then 
			echo "$line is alive!" | tee -a $log
	fi
    done < $file

