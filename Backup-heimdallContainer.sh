#!/bin/bash
#The goal of thie script is to backup my heimdall docker container
function chklogDir {
	if [ -d /home/$USER/.logs ]
	then
 echo "$(date -u)  The log folder was found"  >> /home/$USER/.logs/"$(date '+%Y-%m-%d')-heimdall.log"
 	else 
		echo "$(date -u)  The log folder could not be found, Creating it now" >> /home/$USER/.logs/"$(date '+%Y-%m-%d')-heimdall.log"
		mkdir /home/$USER/.logs/
	fi
}
chklogDir
#Now we need to check that the directories for heimdall exist
function checkDir { 
	if [ -d /home/$USER/heimdall ] # heimdall root container folder
		then
			echo "$(date -u)  The heimdall root directory was found" >> /home/$USER/.logs/"$(date '+%Y-%m-%d')-heimdall.log"
	if [ -d /home/$USER/heimdall/config ] # heimdall Config directory
		then
			echo "$(date -u)  The heimdall config directory was found" >> /home/$USER/.logs/"$(date '+%Y-%m-%d')-heimdall.log"
	if [ -f /home/$USER/heimdall/docker-compose.yml ] # heimdall docker-compose file for creating container
		then
		echo "$(date -u)  The heimdall docker-compose file was found" >> /home/$USER/.logs/"$(date '+%Y-%m-%d')-heimdall.log"

fi
fi
fi
}
checkDir
#We need to check the backup directory exists
function chk-bkupDir {
	if [ -d /home/$USER/container_backups/heimdall ]
	then
	echo "$(date -u)  The backup directory exists" >> /home/$USER/.logs/"$(date '+%Y-%m-%d')-heimdall.log"
else
		echo "$(date -u)  The backup directory could not be found, Creating it now" >> /home/$USER/.logs/"$(date '+%Y-%m-%d')-heimdall.log"
cd /home/$USER/container_backups && mkdir heimdall
fi
}
chk-bkupDir
#Now we need to check the status of our container
function containerStatus {
status=$(docker inspect -f {{.State.Running}} heimdall)
if [ $status == "false" ]
then
	echo "$(date -u) The heimdall container is currently not running, Going to continue backing up the data"  >> /home/$USER/.logs/"$(date '+%Y-%m-%d')-heimdall.log"
else
	echo "$(date -u)  The heimdall container is currently running, Aborting Task!"  >> /home/$USER/.logs/"$(date '+%Y-%m-%d')-heimdall.log"
	exit
fi
}
#Now we're gonna backup our data
function bkup_data {
	if [ $status == "false" ]
	then
if [ -d /home/$USER/container_backups/heimdall ]
then
	cd /home/$USER/heimdall 
	tar -cvzf /home/$USER/container_backups/heimdall/"$(date '+%d-%m-%Y-%I-%H-%M')-heimdall-dataBackup.tar.gz" *
	sleep 3
cd /home/$USER/container_backups/heimdall/
	docker image save heimdall | gzip > "$(date '+%d-%m-%Y-%I-%H-%M')-heimdall_dockerImg.tar.gz"
echo "$(date -u)  The backup task has completed successfully" >> /home/$USER/.logs/"$(date '+%Y-%m-%d')-heimdall.log"
 fi
fi
}
containerStatus
bkup_data
