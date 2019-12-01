###################################################################################
#	Author: H.M. Shah Paran Ali
#	OS Environment: Linux
#	Description: This Tutorial will be helped to increase connection limit and 
#					solve too many open files problem	
#	Email: paran.duet@gmail.com
###################################################################################

Too Check Limit Connection:
ulimit -n
### For Check Soft Limit ###
ulimit -Sn

### For Check Hard Limit ###
ulimit -Hn

##### Temporary Set of limit Connection ######
ulimit -n 65000

########## Permanently Set of Limit Connection ########

vi /etc/security/limits.conf

Paste following towards end:

*         hard    nofile      65000
*         soft    nofile      65000
root      hard    nofile      65000
root      soft    nofile      65000

############ Set File Descriptor Limit ############

vi /etc/sysctl.conf

Add Following or edit:
fs.file-max=500000

### For Immediate Effect do the following command ####
sysctl -p

#### To Check File descriptor limit #####

cat /proc/sys/fs/file-max