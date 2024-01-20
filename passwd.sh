echo "$LogTime uss: [$UserName]# Changing all the user passwords to Cyb3rPatr!0t$." >> output.log
	##Look for valid users that have different UID that not 1000+
	cut -d: -f1,3 /etc/passwd | egrep ':[0-9]{4}$' | cut -d: -f1 > users
	##Looks for users with the UID and GID of 0
	hUSER=`cut -d: -f1,3 /etc/passwd | egrep ':[0]{1}$' | cut -d: -f1`
	echo "$hUSER is a hidden user"
	sed -i '/root/ d' users

	PASS='Cyb3rPatr!0t$'
	for x in `cat users`
	do
		echo -e "$PASS\n$PASS" | passwd $x >> output.log
		echo -e "Password for $x has been changed."
		##Changes the USER password policy
		chage -M 90 -m 7 -W 15 $x
	done
echo "$LogTime uss: [$UserName]# Passwords have been changed." >> output.log

	pause
