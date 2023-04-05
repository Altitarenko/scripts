#!/bin/bash
file=$(cat spisok_linux)

for line in $file 
    do
      ping -c 1 $line
      if test $? -ne 0 
        then echo "$line is DEAD"
	else echo "$line is ALIVE"	
      fi
   	    echo $line 
    done | tee  lg.txt
