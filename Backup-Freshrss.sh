#!/bin/bash
#The goal of this script is to backup my freshrss docker instance
#We need to check the backup directory exists
function chkdir_bkup {
	if [ -d /home/$USER/container_backups/freshrss ]
	then
		echo "$(date -u)  The backup directory has been found" >> /home/$USER/.logs/"$(date '+%Y-%m-%d')-freshrss.log"
else
	echo "$(date -u)  The backup directory could not be found, Creating it now" >> /home/$USER/.logs/"$(date '+%Y-%m-%d')-freshrss.log"
mkdir /home/$USER/container_backups/freshrss/
fi
}
chkdir_bkup
#Now We need to check if the backup log directory exists
function chklogsDir {
if [ /home/$USER/.logs ]
then 
echo "$(date -u)  The log directory has been found" >> /home/$USER/.logs/"$(date '+%Y-%m-%d')-freshrss.log"
else
	echo "$(date -u)  The log directory could not be found" >> /home/$USER/.logs/"$(date '+%Y-%m-%d')-freshrss.log"
fi
}
chklogsDir
#Now we need to check if the freshrss container directories exist
function chkdir { 
if [ -d /home/$USER/freshrss ]
then
	echo "$(date -u)  The freshrss root folder has been found" >> /home/$USER/.logs/"$(date '+%Y-%m-%d')-freshrss.log"
else
		echo "$(date -u)  The freshrss folder could not be found" >> /home/$USER/.logs/"$(date '+%Y-%m-%d')-freshrss.log"
fi
	if [ -d /home/$USER/freshrss/config ]
	then
			echo "$(date -u)  The freshrss config folder has been found" >> /home/$USER/.logs/"$(date '+%Y-%m-%d')-freshrss.log"
	else
	echo "$(date -u) The freshrss config folder could not be found." >> /home/$USER/.logs/"$(date '+%Y-%m-%d')-freshrss.log"
fi
}
chkdir
#Now we need to check the status of the container
function containerStatus {
status=$(docker inspect -f {{.State.Running}} freshrss)
if [ $status == "false" ]
then
	echo "$(date -u) The freshrss container is currently not running, Going to continue backing up the data"  >> /home/$USER/.logs/"$(date '+%Y-%m-%d')-freshrss.log"
else
	echo "$(date -u)  The freshrss container is currently running, Exiting now!"  >> /home/$USER/.logs/"$(date '+%Y-%m-%d')-freshrss.log"
	exit
fi
}
containerStatus
#Now we need to backup the data of the container
function bkupData {
	if [ -d /home/$USER/container_backups ]
	then
		if [ -d /home/$USER/freshrss ]
		then
			tar -cvzf /home/$USER/container_backups/freshrss/"$(date '+%Y-%m-%d')-freshrss_data.tar.gz" *
			sleep 3
			cd /home/$USER/container_backups/freshrss && docker image save freshrssbackup | gzip > "$(date '+%Y-%m-%d')-freshrss-dockerImage.tar.gz"
				echo "$(date -u)  The freshrss backup has completed sucessfully, Exiting now!"  >> /home/$USER/.logs/"$(date '+%Y-%m-%d')-freshrss.log"
else
					echo "$(date -u)  The freshrss backup did not complete sucessfully, Exiting now!"  >> /home/$USER/.logs/"$(date '+%Y-%m-%d')-freshrss.log"

fi
fi
}
bkupData
