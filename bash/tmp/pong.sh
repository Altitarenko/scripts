#!/bin/bash

file=spisok_linux
log=logping.txt
while IFS='' read -r line || [ "$line" ] ; do
#while read -r line;  do 
        echo "Ping to $line" 
	ping -c 2 $line  
	if [[ $? -eq 0 ]] ; 
        	then 
			echo "$line is alive!" 
	fi
    done < $file >> gg.txt

