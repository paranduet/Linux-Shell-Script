#!/bin/bash   
###################################################################################
#	Author: H.M. Shah Paran Ali
#	OS Environment: RHEL 6.x and 7.x
#	Description: Automatically Password Policy Implementation Script for RedHat
#	Email: paran.duet@gmail.com
###################################################################################

##### Password Aging Information #################
MX_DAYS=`grep 'PASS_MAX_DAYS' /etc/login.defs | grep -v '#' | awk '{print $2}'`; 
MN_DAYS=`grep 'PASS_MIN_DAYS' /etc/login.defs | grep -v '#' | awk '{print $2}'`; 
MN_LEN=`grep 'PASS_MIN_LEN' /etc/login.defs | grep -v '#' | awk '{print $2}'`;
WN_AGE=`grep 'PASS_WARN_AGE' /etc/login.defs | grep -v '#' | awk '{print $2}'`;

######### Recommended data ############### 
maximum_days=90
minimum_days=7
minimum_len=7
warning_age=7
remember=3
try_attempt=3

######## Find Out OS Version #############
osVersion=`cat /etc/redhat-release | awk '{print $7}'`;
echo "Warning!!! Please open another session of this server before execute this process."
echo "Since any interruption may result unavailability"
read -p "Would you like to execute the process [Y/N] : " feedback
	if [ $feedback == 'Y' ] || [ $feedback == 'y' ] ; then
		if [ $osVersion == "7.4" ] || [ $osVersion == "7.0" ]; then
			##### File Backup Purpose ###########
			yes|cp -R  /etc/login.defs  /etc/login.defsBK
			yes|cp -R /etc/pam.d/password-auth /root/Documents/password-authBK
			yes|cp -R /etc/pam.d/system-auth /root/Documents/system-authBK
			yes|cp -R /etc/security/pwquality.conf /root/Documents/pwquality.confBK
			## Configuration for OS 7 or more";
			echo "/etc/login.defs file check and configuration :" $osVersion ;
			if [ $MX_DAYS -ne $maximum_days ] ; then 
				### Configure Maximum Password
				mx_count=` grep 'PASS_MAX_DAYS' /etc/login.defs | grep -v '#'`; sed -i 's/'"$mx_count"'/PASS_MAX_DAYS	'"$maximum_days"'/g' /etc/login.defs	
				echo "Maximum days configuration successfully done"
			else 
				echo "Maximum days configuration already done"; 
			fi

			if [ $MN_DAYS -ne $minimum_days ] ; then 
				
				mn_count=` grep 'PASS_MIN_DAYS' /etc/login.defs | grep -v '#'`; sed -i 's/'"$mn_count"'/PASS_MIN_DAYS	'"$minimum_days"'/g' /etc/login.defs	
				echo "Minimum days configuration successfully done"
			else 
				echo "Minimum days already configured"; 
			fi

			if [ $MN_LEN -ne $minimum_len ] ; then 
				mn_len_count=`grep 'PASS_MIN_LEN' /etc/login.defs | grep -v '#'`; sed -i 's/'"$mn_len_count"'/PASS_MIN_LEN	'"$minimum_len"'/g' /etc/login.defs
				echo "Minium length configuration successfully done" ; 
			else 
				echo "Minimum Length Already Configured"; 
			fi

			if [ $WN_AGE -ne $warning_age ] ; then
				wn_count=`grep 'PASS_WARN_AGE' /etc/login.defs | grep -v '#'`; sed -i 's/'"$wn_count"'/PASS_WARN_AGE	'"$warning_age"'/g' /etc/login.defs
				echo "Password Warning AGE Successfully Configured" ; 
			else 
				echo "Warning Already Configured"; 
			fi
			
			echo "Minimum Length Configuration "
			minLen=`grep ^minlen /etc/security/pwquality.conf | awk '{print $3}' | grep -v '#'`;
			minLenString=`grep ^minlen /etc/security/pwquality.conf | grep -v '#'`;
			if [ ! -z "$minLenString" ] ; then 
				sed -i 's/'"$minLenString"'/minlen  = '"$minimum_len"'/g' /etc/security/pwquality.conf ; 
			else 
				echo "############# Added By Paran ########"  >> /etc/security/pwquality.conf; 
				echo "minlen  = "$minimum_len >> /etc/security/pwquality.conf; 
			fi
			
			echo "Digit Configuration"
			minNum=`grep ^dcredit /etc/security/pwquality.conf | grep -v '#'`; 
			if [ -z "$minNum" ] ; then  
				echo "dcredit = -1" >> /etc/security/pwquality.conf; 
			else 
				echo " Already Done"; 
			fi
			
			echo "Lower Case Configuration"
			lowCase=`grep ^lcredit /etc/security/pwquality.conf | grep -v '#'`; 
			if [ -z "$lowCase" ] ; then  
				echo "lcredit = -1" >> /etc/security/pwquality.conf; 
			else 
				echo " Already Done"; 
			fi
			
			echo "Upper Case Configuration"
			upCase=`grep ^ucredit /etc/security/pwquality.conf | grep -v '#'`; 
			if [ -z "$upCase" ] ; then  
				echo "ucredit = -1" >> /etc/security/pwquality.conf; 
			else 
				echo " Already Done"; 
			fi
			
			echo "Special Character Configuration"
			OthCase=`grep ^ocredit /etc/security/pwquality.conf | grep -v '#'`; 
			if [ -z "$OthCase" ] ; then  
				echo "ocredit = -1" >> /etc/security/pwquality.conf; 
			else 
				echo " Already Done"; 
			fi
			
			###################### password-auth and system-auth file configuration #########################
			################ password Combination ##################
			pass_comb=`grep pam_cracklib.so /etc/pam.d/password-auth | grep -v '#'`;
			if [ ! -z "$pass_comb" ] ; then 
				sed -i 's/'"$pass_comb"'/password		requisite		pam_cracklib.so try_first_pass retry=3 minlen=7 dcredit=- 1 ucredit=-1 ocredit=-1 lcredit=-1/g'  /etc/pam.d/password-auth ;
			else
				echo "password		requisite		pam_cracklib.so try_first_pass retry=3 minlen=7 dcredit=- 1 ucredit=-1 ocredit=-1 lcredit=-1" >> /etc/pam.d/password-auth;
			fi
			
			pass_comb=`grep pam_cracklib.so /etc/pam.d/system-auth | grep -v '#'`;
			if [ ! -z "$pass_comb" ] ; then 
				sed -i 's/'"$pass_comb"'/password		requisite		pam_cracklib.so try_first_pass retry=3 minlen=7 dcredit=- 1 ucredit=-1 ocredit=-1 lcredit=-1/g'  /etc/pam.d/system-auth ;
			else
				echo "password		requisite		pam_cracklib.so try_first_pass retry=3 minlen=7 dcredit=- 1 ucredit=-1 ocredit=-1 lcredit=-1" >> /etc/pam.d/system-auth;
			fi

			############## pam_faillock configuration #################
			pam_faillock=`egrep '^auth\s+required\s+pam_faillock.so' /etc/pam.d/password-auth | grep -v '#'`; 
			if [ ! -z "$pam_faillock" ] ; then 
				sed -i 's/'"$pam_faillock"'/auth	required	pam_faillock.so preauth audit silent deny=3 unlock_time=900/g'  /etc/pam.d/password-auth ; 
			else
				echo "######## Added By Paran Due to Password Policy Implementation ######" >> /etc/pam.d/password-auth;
				echo "auth	required	pam_faillock.so preauth audit silent deny=3 unlock_time=900" >> /etc/pam.d/password-auth; 
			fi

			pam_faillock=`egrep '^auth\s+required\s+pam_faillock.so' /etc/pam.d/system-auth | grep -v '#'`; 
			if [ ! -z "$pam_faillock" ] ; then 
				sed -i 's/'"$pam_faillock"'/auth	required	pam_faillock.so preauth audit silent deny=3 unlock_time=900/g'  /etc/pam.d/system-auth ; 
			else
				echo "######## Added By Paran Due to Password Policy Implementation #####" >> /etc/pam.d/system-auth;
				echo "auth		required		pam_faillock.so preauth audit silent deny=3 unlock_time=900" >> /etc/pam.d/system-auth; 
			fi

			############### pam_unix.so configure #################
			pam_unix=`grep 'success.*pam_unix.so' /etc/pam.d/password-auth | grep -v '#'`; 
			if [ ! -z "$pam_unix" ] ; then 
				sed -i 's/'"$pam_unix"'/auth		[success=1 default=bad]		pam_unix.so/g'  /etc/pam.d/password-auth ; 
			else 
				echo "auth		[success=1 default=bad]		pam_unix.so" >> /etc/pam.d/password-auth; 
			fi

			pam_unix=`grep 'success.*pam_unix.so' /etc/pam.d/system-auth | grep -v '#'`; 
			if [ ! -z "$pam_unix" ] ; then 
				sed -i 's/'"$pam_unix"'/auth	[success=1 default=bad]		pam_unix.so/g'  /etc/pam.d/system-auth ; 
			else 
				echo "auth	[success=1 default=bad]		pam_unix.so" >> /etc/pam.d/system-auth; 
			fi
			
			################## authfail Configure ##################
			authfail=`grep 'default.*pam_faillock.so' /etc/pam.d/password-auth | grep -v '#'`; 
			if [ ! -z "$authfail" ] ; then 
				sed -i 's/'"$authfail"'/auth   [default=die]  pam_faillock.so authfail audit deny=3 unlock_time=900/g'  /etc/pam.d/password-auth ; 
			else 
				echo "auth	[default=die]	pam_faillock.so authfail audit deny=3 unlock_time=900" >> /etc/pam.d/password-auth; 
			fi

			authfail=`grep 'default.*pam_faillock.so' /etc/pam.d/system-auth | grep -v '#'`; 
			if [ ! -z "$authfail" ] ; then 
				sed -i 's/'"$authfail"'/auth   [default=die]  pam_faillock.so authfail audit deny=3 unlock_time=900/g'  /etc/pam.d/system-auth ; 
			else 
				echo "auth	[default=die]	pam_faillock.so authfail audit deny=3 unlock_time=900" >> /etc/pam.d/system-auth; 
			fi
			
			################## Authsucc Configure ###################
			authsucc=`grep 'sufficient.*pam_faillock.so' /etc/pam.d/password-auth | grep -v '#'`;  
			if [ ! -z "$authsucc" ] ; then 
				sed -i 's/'"$authsucc"'/auth            sufficient                              pam_faillock.so authsucc audit deny=5 unlock_time=900/g'  /etc/pam.d/password-auth ;
			else 
				echo "auth            sufficient                              pam_faillock.so authsucc audit deny=5 unlock_time=900" >> /etc/pam.d/password-auth; 
			fi

			authsucc=`grep 'sufficient.*pam_faillock.so' /etc/pam.d/system-auth | grep -v '#'`;  
			if [ ! -z "$authsucc" ] ; then 
				sed -i 's/'"$authsucc"'/auth            sufficient                              pam_faillock.so authsucc audit deny=5 unlock_time=900/g'  /etc/pam.d/system-auth ;
			else 
				echo "auth            sufficient                              pam_faillock.so authsucc audit deny=5 unlock_time=900" >> /etc/pam.d/system-auth; 
			fi
			################ Remember Configure #########################

			remember=`grep 'password.*remember' /etc/pam.d/password-auth | grep -v '#'`; 
			if [ ! -z "$remember" ] ; then 
				sed -i 's/'"$remember"'/password    sufficient    pam_unix.so remember=3/g'  /etc/pam.d/password-auth ; 
			else 
				echo "password    sufficient    pam_unix.so remember=3" >> /etc/pam.d/system-auth; 
			fi

			remember=`grep 'password.*remember' /etc/pam.d/system-auth | grep -v '#'`; 
			if [ ! -z "$remember" ] ; then 
				sed -i 's/'"$remember"'/password    sufficient    pam_unix.so remember=3/g'  /etc/pam.d/system-auth ; 
			else 
				echo "password    sufficient    pam_unix.so remember=3" >> /etc/pam.d/system-auth; 
			fi

			remember=`grep 'required.*remember' /etc/pam.d/password-auth | grep -v '#'`; 
			if [ ! -z "$remember" ] ; then 
				sed -i 's/'"$remember"'/password    required    pam_pwhistory.so    remember=3/g'  /etc/pam.d/password-auth ; 
			else 
				echo "password    required    pam_pwhistory.so    remember=3" >> /etc/pam.d/password-auth; 
			fi

			remember=`grep 'required.*remember' /etc/pam.d/system-auth | grep -v '#'`; 
			if [ ! -z "$remember" ] ; then 
				sed -i 's/'"$remember"'/password    required    pam_pwhistory.so    remember=3/g'  /etc/pam.d/system-auth ; 
			else 
				echo "password    required    pam_pwhistory.so    remember=3" >> /etc/pam.d/system-auth; 
			fi
			###################### End of password-auth and system-auth file configuration #########################
			################ End of RHEL 7 and above version ##########################
			################ Process Reverse Purpose #################
			read -p "Would you like to reverse the process [Y/N] : " reverse
			if [ $reverse == 'Y' ] || [ $reverse == 'y' ] ; then 
				cat /etc/login.defsBK > /etc/login.defs
				cat /root/Documents/password-authBK > /etc/pam.d/password-auth
				cat /root/Documents/system-authBK > /etc/pam.d/system-auth
				cat /root/Documents/pwquality.confBK > /etc/security/pwquality.conf
			else
				echo "Password Policy Hardening Successfully Finished on RHEL " $osVersion;
				exit;
			fi
			
		elif [ $osVersion == "6.0" ] || [ $osVersion == "6.4" ] || [ $osVersion == "6.5" ] ; then
			echo "Operating System: RHEL 6 and < 7 ";
			##### File Backup Purpose ###########
			yes|cp -R  /etc/login.defs  /etc/login.defsBK
			yes|cp -R /etc/pam.d/password-auth /root/Documents/password-authBK
			yes|cp -R /etc/pam.d/system-auth /root/Documents/system-authBK
			
			echo "/etc/login.defs file check and configuration :" $osVersion ;
			if [ $MX_DAYS -ne $maximum_days ] ; then 
				### Configure Maximum Password
				mx_count=` grep 'PASS_MAX_DAYS' /etc/login.defs | grep -v '#'`; sed -i 's/'"$mx_count"'/PASS_MAX_DAYS	'"$maximum_days"'/g' /etc/login.defs	
				echo "Maximum days configuration successfully done"
			else 
				echo "Maximum days configuration already done"; 
			fi

			if [ $MN_DAYS -ne $minimum_days ] ; then 
				
				mn_count=` grep 'PASS_MIN_DAYS' /etc/login.defs | grep -v '#'`; sed -i 's/'"$mn_count"'/PASS_MIN_DAYS	'"$minimum_days"'/g' /etc/login.defs	
				echo "Minimum days configuration successfully done"
			else 
				echo "Minimum days already configured"; 
			fi;

			if [ $MN_LEN -ne $minimum_len ] ; then 
				mn_len_count=`grep 'PASS_MIN_LEN' /etc/login.defs | grep -v '#'`; sed -i 's/'"$mn_len_count"'/PASS_MIN_LEN	'"$minimum_len"'/g' /etc/login.defs
				echo "Minium length configuration successfully done" ; 
			else 
				echo "Minimum Length Already Configured"; 
			fi

			if [ $WN_AGE -ne $warning_age ] ; then
				wn_count=`grep 'PASS_WARN_AGE' /etc/login.defs | grep -v '#'`; sed -i 's/'"$wn_count"'/PASS_WARN_AGE	'"$warning_age"'/g' /etc/login.defs
				echo "Password Warning AGE Successfully Configured" ; 
			else 
				echo "Warning Already Configured"; 
			fi
			
			###################### password-auth and system-auth file configuration #########################
			
			################ password Combination ##################
			pass_comb=`grep pam_cracklib.so /etc/pam.d/password-auth | grep -v '#'`;
			if [ ! -z "$pass_comb" ] ; then 
				sed -i 's/'"$pass_comb"'/password		requisite		pam_cracklib.so try_first_pass retry=3 minlen=7 dcredit=- 1 ucredit=-1 ocredit=-1 lcredit=-1/g'  /etc/pam.d/password-auth ;
			else
				echo "password		requisite		pam_cracklib.so try_first_pass retry=3 minlen=7 dcredit=- 1 ucredit=-1 ocredit=-1 lcredit=-1" >> /etc/pam.d/password-auth;
			fi
			
			pass_comb=`grep pam_cracklib.so /etc/pam.d/system-auth | grep -v '#'`;
			if [ ! -z "$pass_comb" ] ; then 
				sed -i 's/'"$pass_comb"'/password		requisite		pam_cracklib.so try_first_pass retry=3 minlen=7 dcredit=- 1 ucredit=-1 ocredit=-1 lcredit=-1/g'  /etc/pam.d/system-auth ;
			else
				echo "password		requisite		pam_cracklib.so try_first_pass retry=3 minlen=7 dcredit=- 1 ucredit=-1 ocredit=-1 lcredit=-1" >> /etc/pam.d/system-auth;
			fi

			############## pam_faillock configuration #################
			pam_faillock=`egrep '^auth\s+required\s+pam_faillock.so' /etc/pam.d/password-auth | grep -v '#'`; 
			if [ ! -z "$pam_faillock" ] ; then 
				sed -i 's/'"$pam_faillock"'/auth	required	pam_faillock.so preauth audit silent deny=3 unlock_time=900/g'  /etc/pam.d/password-auth ; 
			else
				echo "######## Added By Paran Due to Password Policy Implementation ######" >> /etc/pam.d/password-auth;
				echo "auth		required	pam_faillock.so preauth audit silent deny=3 unlock_time=900" >> /etc/pam.d/password-auth; 
			fi

			pam_faillock=`egrep '^auth\s+required\s+pam_faillock.so' /etc/pam.d/system-auth | grep -v '#'`; 
			if [ ! -z "$pam_faillock" ] ; then 
				sed -i 's/'"$pam_faillock"'/auth		required		pam_faillock.so preauth audit silent deny=3 unlock_time=900/g'  /etc/pam.d/system-auth ; 
			else
				echo "######## Added By Paran Due to Password Policy Implementation #####" >> /etc/pam.d/system-auth;
				echo "auth		required		pam_faillock.so preauth audit silent deny=3 unlock_time=900" >> /etc/pam.d/system-auth; 
			fi

			############### pam_unix.so configure #################
			pam_unix=`grep 'success.*pam_unix.so' /etc/pam.d/password-auth | grep -v '#'`; 
			if [ ! -z "$pam_unix" ] ; then 
				sed -i 's/'"$pam_unix"'/auth	[success=1 default=bad]		pam_unix.so/g'  /etc/pam.d/password-auth ; 
			else 
				echo "auth	[success=1 default=bad]		pam_unix.so" >> /etc/pam.d/password-auth; 
			fi

			pam_unix=`grep 'success.*pam_unix.so' /etc/pam.d/system-auth | grep -v '#'`; 
			if [ ! -z "$pam_unix" ] ; then 
				sed -i 's/'"$pam_unix"'/auth	[success=1 default=bad]		pam_unix.so/g'  /etc/pam.d/system-auth ; 
			else 
				echo "auth	[success=1 default=bad]		pam_unix.so" >> /etc/pam.d/system-auth; 
			fi
			
			################## authfail Configure ##################
			authfail=`grep 'default.*pam_faillock.so' /etc/pam.d/password-auth | grep -v '#'`; 
			if [ ! -z "$authfail" ] ; then 
				sed -i 's/'"$authfail"'/auth   [default=die]  pam_faillock.so authfail audit deny=3 unlock_time=900/g'  /etc/pam.d/password-auth ; 
			else 
				echo "auth	[default=die]	pam_faillock.so authfail audit deny=3 unlock_time=900" >> /etc/pam.d/password-auth; 
			fi

			authfail=`grep 'default.*pam_faillock.so' /etc/pam.d/system-auth | grep -v '#'`; 
			if [ ! -z "$authfail" ] ; then 
				sed -i 's/'"$authfail"'/auth   [default=die]  pam_faillock.so authfail audit deny=3 unlock_time=900/g'  /etc/pam.d/system-auth ; 
			else 
				echo "auth	[default=die]	pam_faillock.so authfail audit deny=3 unlock_time=900" >> /etc/pam.d/system-auth; 
			fi
			
			################## Authsucc Configure ###################
			authsucc=`grep 'sufficient.*pam_faillock.so' /etc/pam.d/password-auth | grep -v '#'`;  
			if [ ! -z "$authsucc" ] ; then 
				sed -i 's/'"$authsucc"'/auth            sufficient                              pam_faillock.so authsucc audit deny=5 unlock_time=900/g'  /etc/pam.d/password-auth ;
			else 
				echo "auth            sufficient                              pam_faillock.so authsucc audit deny=5 unlock_time=900" >> /etc/pam.d/password-auth; 
			fi

			authsucc=`grep 'sufficient.*pam_faillock.so' /etc/pam.d/system-auth | grep -v '#'`;  
			if [ ! -z "$authsucc" ] ; then 
				sed -i 's/'"$authsucc"'/auth            sufficient                              pam_faillock.so authsucc audit deny=5 unlock_time=900/g'  /etc/pam.d/system-auth ;
			else 
				echo "auth            sufficient                              pam_faillock.so authsucc audit deny=5 unlock_time=900" >> /etc/pam.d/system-auth; 
			fi
			################ Remember Configure #########################

			remember=`grep 'password.*remember' /etc/pam.d/password-auth | grep -v '#'`; 
			if [ ! -z "$remember" ] ; then 
				sed -i 's/'"$remember"'/password		sufficient		pam_unix.so remember=3/g'  /etc/pam.d/password-auth ; 
			else 
				echo "password		sufficient		pam_unix.so remember=3" >> /etc/pam.d/system-auth; 
			fi

			remember=`grep 'password.*remember' /etc/pam.d/system-auth | grep -v '#'`; 
			if [ ! -z "$remember" ] ; then 
				sed -i 's/'"$remember"'/password		sufficient		pam_unix.so remember=3/g'  /etc/pam.d/system-auth ; 
			else 
				echo "password		sufficient		pam_unix.so remember=3" >> /etc/pam.d/system-auth; 
			fi

			remember=`grep 'required.*remember' /etc/pam.d/password-auth | grep -v '#'`; 
			if [ ! -z "$remember" ] ; then 
				sed -i 's/'"$remember"'/password		required		pam_pwhistory.so    remember=3/g'  /etc/pam.d/password-auth ; 
			else 
				echo "password		required		pam_pwhistory.so    remember=3" >> /etc/pam.d/password-auth; 
			fi

			remember=`grep 'required.*remember' /etc/pam.d/system-auth | grep -v '#'`; 
			if [ ! -z "$remember" ] ; then 
				sed -i 's/'"$remember"'/password		required		pam_pwhistory.so    remember=3/g'  /etc/pam.d/system-auth ; 
			else 
				echo "password		required		pam_pwhistory.so    remember=3" >> /etc/pam.d/system-auth; 
			fi
			
			################ Process Reverse Purpose #################
			read -p "Would you like to reverse the process [Y/N] : " reverse
			if [ $reverse == 'Y' ] || [ $reverse == 'y' ] ; then 
				cat /etc/login.defsBK > /etc/login.defs
				cat /root/Documents/password-authBK > /etc/pam.d/password-auth
				cat /root/Documents/system-authBK > /etc/pam.d/system-auth
				cat /root/Documents/pwquality.confBK > /etc/security/pwquality.conf
			else
				echo "Password Policy Hardening Successfully Finished on RHEL " $osVersion;
				exit;
			fi
		fi
	else
		echo "Process has been terminated";
		exit;
	fi