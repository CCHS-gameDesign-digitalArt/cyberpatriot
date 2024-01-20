#!/bin/bash
UserName=$(whoami)
LogTime=$(date '+%Y-%d %H:%M;%S')
DE=$(echo $XDG_CURRENT_DESKTOP)

## Adds a pause statement
pause(){
	read -p "Press [Enter] key to continue..." fakeEnter
}

## Exits the script
exit20(){
	exit 1
	clear
}

## Detects the Operating System
gcc || sudo apt-get install -y gcc
gcc --version | grep -i ubuntu
if [ $? -eq 0 ]; then
	opsys="Ubuntu"
fi
gcc --version | grep -i debian >> /dev/null
if [ $? -eq 0 ]; then
	opsys="Debian"
fi

## Updates the operating system, kernel, firefox, and libre office, and also installs 'clamtk'
update(){
	case "$opsys" in
		"Debian"|"Ubuntu")
			sudo add-apt-repository -y ppa:libreoffice/ppa
			wait
			sudo apt-get update -y
			wait
			sudo apt-get upgrade -y
			wait
			sudo apt-get dist-upgrade -y
			wait
			killall firefox
			wait
			sudo apt-get --purge --reinstall install firefox -y
			wait
			sudo apt-get install clamtk -y
			wait
			pause
		;;
	esac
}

## Creates copies of critical files
backup() {
	mkdir -p /BackUps
	## Backups the sudoers file
	sudo cp /etc/sudoers /BackUps
	## Backups the home directory
	cp /etc/passwd /BackUpsd
	## Backups the log files
	cp -r /var/log /BackUps
	## Backups the passwd file
	cp /etc/passwd /BackUps
	## Backups the group file
	cp /etc/group /BackUps
	## Backups the shadow file
	cp /etc/shadow /BackUps
	## Backups the /var/spool/mail
	cp /var/spool/mail /Backups
	## Backups all the home directories
	for x in $(ls /home); do
		cp -r /home/$x /BackUps
	done
	pause
}

## Sets Automatic Updates on the machine.
autoUpdate() {
	echo "$LogTime uss: [$UserName]# Setting auto updates." >> output.log
	case "$opsys" in
		"Debian"|"Ubuntu")
			## Set daily updates
			sed -i -e 's/APT::Periodic::Update-Package-Lists.*\+/APT::Periodic::Update-Package-Lists "1";/' /etc/apt/apt.conf.d/10periodic
			sed -i -e 's/APT::Periodic::Download-Upgradeable-Packages.*\+/APT::Periodic::Download-Upgradeable-Packages "0";/' /etc/apt/apt.conf.d/10periodic
			## Sets default browser
			sed -i 's/x-scheme-handler\/http=.*/x-scheme-handler\/http=firefox.desktop/g' /home/$UserName/.local/share/applications/mimeapps.list
			## Set "install security updates"
			grep -q "deb http://security.ubuntu.com/ubuntu/ trusty-security universe main multiverse restricted" /etc/apt/sources.list || echo "deb http://security.ubuntu.com/ubuntu/ trusty-security universe main multiverse restricted" >> /etc/apt/sources.list
			echo "###Automatic updates###" >> output.log
			cat /etc/apt/apt.conf.d/10periodic >> output.log
			echo "" >> output.log
			echo "###Important Security Updates###" >> output.log
			cat /etc/apt/sources.list >> output.log
			pause
		;;
	esac
}

## Finds all prohibited files on the machine and deletes them
pFiles() {
	echo "$LogTime uss: [$UserName]# Deleting media files..." >> output.log
	## Media files
	echo "###MEDIA FILES###" >> pFiles.log
	find / -name "*.mov" -type f >> pFiles.log
	find / -name "*.mp4" -type f >> pFiles.log
	find / -name "*.mp3" -type f >> pFiles.log
	find / -name "*.wav" -type f >> pFiles.log
	## Pictures
	echo "###PICTURES###" >> pFiles.log
	find / -name "*.jpg" -type f >> pFiles.log
	find / -name "*.jpeg" -type f >> pFiles.log
	## Other Files
	echo "###OTHER###" >> pFiles.log
	find / -name "*.tar.gz" -type f >> pFiles.log
	find / -name "*.tar" -type f >> pFiles.log
	find / -name "*.gz" -type f >> pFiles.log
	## Deletes the found files
	xargs rm -rf < pFiles.log
	echo "$LogTime uss: [$UserName]# Media files deleted." >> output.log
	pause
}

## Main menu
while true; do
	clear
	echo "###MAIN MENU###"
	echo "1. Update System"
	echo "2. Backup Critical Files"
	echo "3. Set Automatic Updates"
	echo "4. Delete Prohibited Files"
	echo "5. Exit"
	read -p "Enter your choice [1-5]: " choice
	case $choice in
		1)
			update
			;;
		2)
			backup
			;;
		3)
			autoUpdate
			;;
		4)
			pFiles
			;;
		5)
			exit20
			;;
		*)
			echo "Invalid option. Please enter a number between 1 and 5."
			pause
			;;
	esac
done
