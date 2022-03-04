#!/bin/bash
#The goal of this script is to backup my prometheus docker instance.
#Check to see if the log directory exists.
function chklogDir {
	if [ -d /home/$USER/.logs/ ]
	then 
	echo "$(date -u)  The log folder was found"  >> /home/$USER/.logs/"$(date '+%Y-%m-%d')-prometheus.log"
	else 
		echo "$(date -u)  The log folder could not be found, Creating it now"
		mkdir /home/$USER/.logs/
	fi
}
chklogDir
#Get the status of the prometheus container
#The container will be stopped a few minutes before this script executes and will be brought back up a few minutes after.
function containerStatus {
status=$(docker inspect -f {{.State.Running}} prometheus)
if [ $status == "false" ]
then
	echo "$(date -u) The Prometheus container is currently not running, Going to continue backing up the data"  >> /home/$USER/.logs/"$(date '+%Y-%m-%d')-prometheus.log"
else
	echo "$(date -u)  The Prometheus container is currently running, Exiting now!"  >> /home/$USER/.logs/"$(date '+%Y-%m-%d')-prometheus.log"
	exit
fi
}
#Check that the directories mounted to the docker container exist
function checkDir {
	#Check if the prometheus directories exist
	if [ -d /home/$USER/prometheus ]
	then
		echo "$(date -u)  The prometheus root folder was found" >> /home/$USER/.logs/"$(date '+%Y-%m-%d')-prometheus.log"
		fi
		#Prometheus Data directory
		if  [ -d  /home/$USER/prometheus/data ]
		then
	echo "$(date -u)  The prometheus data folder was found" >> /home/$USER/.logs/"$(date '+%Y-%m-%d')-prometheus.log"
			fi
			#Docker-compose file
			if [ -f /home/$USER/prometheus/docker-compose.yml ]
			then 
				echo "$(date -u)  The prometheus docker-compose file was found" >> /home/$USER/.logs/"$(date '+%Y-%m-%d')-prometheus.log"
	fi
}
function check-bkupDir {
if [ -d /home/$USER/container_backups/prometheus ]
then 
echo "$(date -u)  The backup directory exists" >> /home/$USER/.logs/"$(date '+%Y-%m-%d')-prometheus.log"
else
echo "$(date -u)  Could not find the backup directory creating it now." >> /home/$USER/.logs/"$(date '+%Y-%m-%d')-prometheus.log"
cd /home/$USER && mkdir -p container_backups/prometheus/
fi
}
containerStatus
checkDir
check-bkupDir
function bkup_data { 
	if [ $status == "false" ]
	then
if [ -d /home/$USER/container_backups/prometheus ]
then
	cd /home/$USER/prometheus 
	tar -cvzf /home/$USER/container_backups/prometheus/"$(date '+%d-%m-%Y-%I-%H-%M')-Prometheus-dataBackup.tar.gz" *
	sleep 3
cd /home/$USER/container_backups/prometheus/
	docker image save prom/prometheus | gzip > "$(date '+%d-%m-%Y-%I-%H-%M')-Prometheus_dockerImg.tar.gz"
echo "$(date -u)  The backup task has completed successfully" >> /home/$USER/.logs/"$(date '+%Y-%m-%d')-prometheus.log"
 fi
fi
}
bkup_data
