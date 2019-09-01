#!/bin/bash
###################################################################################
#       Author: H.M. Shah Paran Ali
#       OS Environment: RHEL 7.4
#       Description: Script for Scan IP Address
#       Email: paran.duet@gmail.com
###################################################################################


########## To Check Server Up or down from ip List ###########
        for i in $(cat /opt/script/LogFile/ipList.txt) ;
        do
                ping -c 2 ${i}>/dev/null 2>&1 && echo "${i} up and running" || echo "${i} down" ;
        done;
