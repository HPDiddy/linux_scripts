#/bin/bash
#Simple System backup script written by https://github.com/HPDiddy
echo "Please enter your username"
read username
if [ -d /home/$username/.backups ];
then
	echo "The backup directory exists"
else
	echo "The backup directory does not exist, creating it now!" && mkdir ~/.backups
fi
#Do you want to backup your entire system to one tar file?
echo "Do you wish to backup your entire home directory into one tar file? [y/n]"
read answer
if [ "$answer" = "y" ];
then 
	echo "Backing up /home/$username"
	tar -zcf /home/$username/.backups/home.tar.gz /home/$username/*  
	echo "Backup complete!"
else
echo "Ok, I will backup your individual home directories to .backups"
	#This will backup the individual user directorys
echo "Backing up the Music directory..."
	tar -zcf /home/$username/.backups/music.tar.gz /home/$username/Music/
echo "Backing up the Pictures Directory..."
	tar -zcf /home/$username/.backups/pictures.tar.gz /home/$username/Pictures/
echo "Backing up the Videos Directory"
    tar -zcf /home/$username/.backups/videos.tar.gz /home/$username/Videos/
echo "Backing up the Documents Directory"
    tar -zcf /home/$username/.backups/documents.tar.gz /home/$username/Documents/
echo "Backing up the Downloads Directory..."
	tar -zcf /home/$username/.backups/downloads.tar.gz /home/$username/Downloads/
echo "Backing up the Desktop Directory..."
	tar -zcf /home/$username/.backups/desktop.tar.gz /home/$username/Desktop/
echo "Backup Complete!"
fi
echo "Do you wish to move your backup to another directory? [y/n]"
read answer
if [ $answer = "y" ]
then 
	echo "Enter the directory you would like to move your backup to:"
	read directory
	if [ -d $directory ]
	then
	echo "You entered $directory, Is this correct?[Y/n]"
	read answer
else	
	echo "The directory does not exist!"
fi
if [ $answer = "y" ]
then
echo "Moving contents of .backups to $directory" 
	mv /home/$username/.backups/* $directory
	echo "Backup moved sucessfully, Exiting now!"
else
	echo "Your backup is complete and is in /home/$username/.backups"
		echo "Exiting... Goodbye!"
fi
