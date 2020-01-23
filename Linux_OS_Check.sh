#!/bin/bash   
###################################################################################
#	Author: H.M. Shah Paran Ali
#	OS Environment: Linux
#	Description: This script will be used to find out hardening status of the OS
#	Email: paran.duet@gmail.com
###################################################################################

### password policy Checking ########

read -p "Enter your output file name:" result_file; 
output="/root/Documents/$result_file"; 
if [ ! -f "$output" ] ; then 
	touch $output; 
else 
	echo "$output file already exist"; 
fi;

cat /etc/redhat-release >> $output

echo "grep pam_cracklib.so /etc/pam.d/password-auth" >> $output

grep pam_cracklib.so /etc/pam.d/password-auth >> $output

echo "grep pam_cracklib.so /etc/pam.d/system-auth" >> $output
grep pam_cracklib.so /etc/pam.d/system-auth >> $output


echo "egrep '^password\s+sufficient\s+pam_unix.so' /etc/pam.d/password-auth" >> $output
egrep '^password\s+sufficient\s+pam_unix.so' /etc/pam.d/password-auth >> $output


echo "egrep '^password\s+sufficient\s+pam_unix.so' /etc/pam.d/system-auth" >> $output
egrep '^password\s+sufficient\s+pam_unix.so' /etc/pam.d/system-auth >> $output



echo "grep PASS_MAX_DAYS /etc/login.defs" >> $output
grep PASS_MAX_DAYS /etc/login.defs >> $output

echo "grep PASS_MIN_DAYS /etc/login.defs" >> $output
grep PASS_MIN_DAYS /etc/login.defs >> $output


echo "grep PASS_WARN_AGE /etc/login.defs" >> $output
grep PASS_WARN_AGE /etc/login.defs >> $output

echo "useradd -D | grep INACTIVE" >> $output
useradd -D | grep INACTIVE >> $output

echo "cat /etc/shadow | cut -d: -f1" >> $output
cat /etc/shadow | cut -d: -f1 >> $output

# chage --list <user>

echo "stat /etc/passwd" >> $output
stat /etc/passwd >> $output

echo "stat /etc/group" >> $output
stat /etc/group >> $output

echo "stat /etc/shadow" >> $output
stat /etc/shadow >> $output

echo -e "\n\n ####SELinux Information \n" >> $output

echo -e "\n/etc/selinux/config" >> $output

rpm -q libselinux >> $output

echo -e "\n\n Warning Banners" >> $output

echo "cat /etc/motd" >> $output
cat /etc/motd >> $output
echo -e "egrep '(\\v|\\r|\\m|\\s)' /etc/motd" >> $output
egrep '(\\v|\\r|\\m|\\s)' /etc/motd >> $output

echo -e "\n cat /etc/issue" >> $output
cat /etc/issue >> $output
echo -e "\negrep '(\\v|\\r|\\m|\\s)' /etc/issue" >> $output
egrep '(\\v|\\r|\\m|\\s)' /etc/issue >> $output


# /etc/dconf/profile/gdm


# /etc/dconf/db/gdm.d/


echo -e "\n updates and patches information " >> $output
yum check-update >> $output

>>> telnet server

# chkconfig --list


>>>tftp server

# chkconfig–list

echo -e "\n ntp configuration\n" >> $output
echo "grep "^restrict" /etc/ntp.conf" >> $output
grep "^restrict" /etc/ntp.conf >> $output

echo -e "\n NTPD Checking"
#grep "^OPTIONS" /etc/sysconfig/ntpd
#grep "^OPTIONS" /etc/sysconfig/ntpd
(OPTIONS="-u ntp:ntp")

>>>chrony configuration

	#grep "^(server|pool)" etc/chrony.conf
	
	#server <remote-server>

	#grep ^OPTIONS /etc/sysconfig/chronyd
	

>>> DHCP Server

# chkconfig --list 

>>>LDAP server

# chkconfig --list slapd




>>> NFS and RPC
# chkconfig --list 


# chkconfig --list rpcbind





>>>DNS Server

# chkconfig --list named 


>>>FTP Server
# chkconfig --list vsftpd



>>> HTTP server
# chkconfig --list httpd


>>>IMAP and POP3 server
# chkconfig --list dovecot



>>> Samba

# chkconfig --list smb


>>> SNMP Server

# chkconfig --list snmpd


>>>> telnet client

# rpm -q telnet

>>> IP forwarding

# sysctl net.ipv4.ip_forward

# grep "net\.ipv4\.ip_forward" /etc/sysctl.conf /etc/sysctl.d/*


>>>packet redirect

# sysctl net.ipv4.conf.all.send_redirects



# sysctl net.ipv4.conf.default.send_redirects


# grep "net\.ipv4\.conf\.all\.send_redirects" /etc/sysctl.conf
/etc/sysctl.d/*


# grep "net\.ipv4\.conf\.default\.send_redirects" /etc/sysctl.conf
/etc/sysctl.d/*




>>>source routed packets
# sysctl net.ipv4.conf.all.accept_source_route


# sysctl net.ipv4.conf.default.accept_source_route


# grep "net\.ipv4\.conf\.all\.accept_source_route" /etc/sysctl.conf
/etc/sysctl.d/*


# grep "net\.ipv4\.conf\.default\.accept_source_route" /etc/sysctl.conf
/etc/sysctl.d/*



>>>ICMP redirects

# sysctl net.ipv4.conf.all.accept_redirects


# sysctl net.ipv4.conf.default.accept_redirects


# grep "net\.ipv4\.conf\.all\.accept_redirects" /etc/sysctl.conf
/etc/sysctl.d/*


# grep "net\.ipv4\.conf\.default\.accept_redirects" /etc/sysctl.conf
/etc/sysctl.d/*



>>>default deny
# iptables -L



>>>firewall rules for all open ports
# netstat -ln




# iptables -L INPUT -v -n




>>> wireless interfaces

# iwconfig

# iwconfig

>>> audit log storage size
# grepmax_log_file /etc/audit/auditd.conf



>>> modify date and time




# grep time-change /etc/audit/audit.rules
# auditctl -l | grep time-change



>>> login and logout events

# grep logins /etc/audit/audit.rules



>>>access control permission modification events



# grepperm_mod /etc/audit/audit.rules
# auditctl -l | grepperm_mod
