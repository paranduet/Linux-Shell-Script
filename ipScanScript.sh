#!/bin/bash
###################################################################################
#       Author: H.M. Shah Paran Ali
#       OS Environment: RHEL
#       Description: Script for Scan IP Address, to execute the you script you must
#                       Required download or create ipList.txt file
#       Email: paran.duet@gmail.com
###################################################################################


########## To Check Server Up or down from ip List ###########
### if you have limited number of ip address, you can store your ip address in array, like this:
### ipList=('192.168.x.x' '192.168.x.x' '192.168.x.x');
### then for loop will be "for ip in $ipList;" otherwise, store your ip address in a text file and call in for loop, like my current script
        for i in $(cat /opt/script/LogFile/ipList.txt) ;
        do
                ping -c 2 ${i}>/dev/null 2>&1 && echo "${i} up and running" || echo "${i} down" ;
        done;
