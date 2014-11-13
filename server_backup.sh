#!/bin/bash
# author: Aivars Lauzis
# email: lauzis@inbox.lv

function do_backup_folder()
{
    #setting up the variables
    folder_to_backup=$1;
    name_for_folder=$2;
    current_date=$3;
    backup_daily_dir=$4;
    
    
    #doing the concat for the name
    file_name=$backup_daily_dir"/"$name_for_folder"_"$current_date".tar.gz";
    
    #taring into one file all the dir
    #maybe should also comppress, but would increase cpu time...
    tar -czf --absolute-names $file_name $folder_to_backup;
    
}

function do_mysql_backup()
{
    #setting up the variables
    db_daily_dir=$1;
    current_date=$2;
    mysql_user=$3;
    mysql_password=$4;
    
    #command to get all the accesible databases for the user
    mysql_command="mysql -u $mysql_user -p'$mysql_password' -e'SHOW DATABASES;'";
    
    #getting the database names to know what to backup
    #looping through result, some say eval is evil, but could not make this work without eval
    #any suggestions?
    for i in `eval $mysql_command | egrep -v 'information_schema|performance_schema|Database|mysql'`; 
    do
        #concating the target file
        mysql_target_file=$db_daily_dir"/db_"$current_date"."$i".sql"; 
    	echo "Dumping the database:"$i
        #concating the mysql command for dump
    	dump_command="mysqldump --default-character-set=utf8 -u "$mysql_user" -p'"$mysql_password"' "$i" > "$mysql_target_file
        
        #running command, some say eval is evil, but could not make this work without eval
        #any suggestions?
        eval $dump_command;
        #compressing result file;
    	gzip -9f $mysql_target_file;
    done    
    
}



#starting backup
#tries also notify by the email that backup has been started
if [ $mail_notification ]
then
    echo "Starting backup!" | mail -s "[Backup shell script] Starting backup!" $notify_email
fi;

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
settingsfile=$DIR"/bk_settings.cfg";

#checks if settings file exists if not exits
if [ -f "$settingsfile" ] 
then
	source $settingsfile
else
	echo ERR:1 Settings file $settingsfile not found... sorry, can not continue...
	exit
fi





echo $current_date;
echo $1;
case $1 in
    -daily)
        #same as default
        if [ $delete_old_files ]
        then
            #TODO: delete the old files form dir
            echo "DELETING OLD BACKUP FILES OLDER THAN 30 (1 Month old) DAYS FROM DAILY BACKUP";
            find $backup_daily_dir -type f -mtime +30 -exec rm {} \;
        fi
    ;;
   -weekly)
        #TODO:check if the backup files does not exists in daily dir (if exists copy) if not do the routine
        
        
        if [ $delete_old_files ]
        then
            #TODO: delete the old files form dir
            echo "DELETING OLD BACKUP FILES OLDER THAN 180 (6 Months) DAYS FROM WEEKLY BACKUP";
            find $backup_weekly_dir -type f -mtime +180 -exec rm {} \;
        fi
        
        #the code for not existant backup files in daily
        #setting up weekly folders as daily folders
        backup_daily_dir=$backup_weekly_dir;
        db_daily_dir=$db_weekly_dir
    ;;
        
   -monthly)
        if [ $delete_old_files ]
        then
            #TODO: delete the old files form dir
            echo "DELETING OLD BACKUP FILES OLDER THAN 450 DAYS (1.5 years) FROM MONTHLY BACKUP";
            find $backup_monthly_dir -type f -mtime +450 -exec rm {} \;
        fi
        backup_daily_dir=$backup_monthly_dir;
        db_daily_dir=$db_monthly_dir;
    ;;     
esac

#common skript tasks

    #checking if there necassary folders
    if [ ! -d "$backup_daily_dir" ]
    then
        echo WARNING:1 The targed directory missing $backup_daily_dir trying to create
        mkdir "$backup_daily_dir"
        mkdir "$db_daily_dir"
            if [ ! -d "$backup_daily_dir" ]
        then
            echo ERR:2 Could not create $backup_daily_dir,... sorry cant continue;
            exit;
        fi
    fi

    #counter to track names of the folders
    counter=0;
    
    #getting count of the folders to backup    
    folders=${#backup_folders[@]}
    #getting count of the names for the backup destination
    folder_names=${#backup_folder_names[@]}
    
    #checking if count of the names and folders are the same, if not then error
    if [ $folders -neq $folder_names ]
    then
        echo ERR:3 Please check configuration, the count of backup folders and folder names is not the same...sorry, can not continue...
        exit
    fi
    
    #copies the folders to the tar files
    for i in "${backup_folders[@]}"
    do         
        the_folder_name=${backup_folder_names[${counter}]}
        echo Folder to copy : $i
        #calls the function wich is doing the actual copy/archieve process
        do_backup_folder $i $the_folder_name $current_date $backup_daily_dir;
        counter=$(($counter+1));
    done
    
    #checking if have to backup also database
    if [ $mysql_backup ]
    then
        do_mysql_backup $db_daily_dir $current_date $mysql_user $mysql_password;
    fi



#tries also notify by the email that backup has been started
if [ $mail_notification ]
then
    echo "Informing that backup is finished" | mail -s "[Backup shell script] Finished backup" $notify_email
fi;



