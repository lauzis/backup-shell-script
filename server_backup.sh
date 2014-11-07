#!/bin/bash

function do_backup_folder()
{
    folder_to_backup=$1;
    name_for_folder=$2;
    current_date=$3;
    $home_daily_dir=$s4;
    file_name="$home_daily_dir""$name_for_folder""_$current_date.tar.gz";

    tar -cvzf $file_name $folder_to_backup;
    
}



#echo "Starting backup!" | mail -s "[itdep412] Starting backup!" $notify_email

settingsfile='bk_settings.cfg';

#checks if settings file exists if not exits
if [ -f "$settingsfile" ] 
then
	source $settingsfile
else
	echo ERR:1 Settings file $settingsfile not found... sorry, can not continue...
	exit
fi


#checking if there necassary folders
if [ ! -d "$home_daily_dir" ]
then
    echo WARNING:1 The targed directory missing $home_daily_dir trying to create
    mkdir "$home_daily_dir"
    if [ ! -d "$home_daily_dir" ]
    then
        echo ERR:1 Could not create $home_daily_dir,... sorry cant continue;
        exit;
    fi
fi

echo $current_date;
echo $1;
case $1 in
    -test)
        counter=0;
        folders=${#backup_folders[@]}
        folder_names=${#backup_folder_names[@]}
        #echo $folders
        #echo $folder_names
        if [ $folders -neq $folder_names ]
        then
            echo ERR:2 Please check configuration, the count of backup folders and folder names is not the same...sorry, can not continue...
            exit
        fi
    
        for i in "${backup_folders[@]}"
        do
           
            ##echo ${numbers[${i}]}
            the_folder_name=${backup_folder_names[${counter}]}
            echo $the_folder_name
            echo $counter;
            echo $i
            do_backup_folder $i $the_folder_name $current_date $home_daily_dir;
            counter=$(($counter+1));
        done;;
        
   -daily)
      tar -cvzf "$home_daily_dir/home_$current_date.tar.gz" /home/
      tar -cvzf "$settings_daily_dir/etc_$current_date.tar.gz" /etc/;;
   -weekly)
      cp "$home_daily_dir/home_$current_date.tar.gz" "$home_weekly_dir/"
      cp "$settings_daily_dir/etc_$current_date.tar.gz" "$settings_weekly_dir/";;
   -monthly)
      cp "$home_daily_dir/home_$current_date.tar.gz" "$home_monthly_dir/"
      cp "$settings_daily_dir/etc_$current_date.tar.gz" "$settings_monthly_dir/";;
esac

#for i in `mysql -u $mysql_user -p'$mysq_password' -e'SHOW DATABASES;' | egrep -v 'information_schema|performance_schema|Database'`; 
#do 
#	echo $db_daily_dir."db_".$current_date.$i.sql;
#	mysqldump --default-character-set=utf8 -u $mysql_user -p'$mysq_password' $i > /media/backup/daily/db/db_$current_date.$i.sql; 
#	gzip -9f /media/backup/daily/db/db_$current_date.$i.sql;
#	case $1 in
#		-weekly) cp /media/backup/daily/db/db_$current_date.$i.sql.gz /media/backup/weekly/db/;;
#		-monthly) cp /media/backup/daily/db/db_$current_date.$i.sql.gz /media/backup/monthly/db/;;
#	esac
#done

#echo "Informing that backup is finished" | mail -s "[itdep412] Finished backup" $notify_email




#for i in "mysql -u'lauzis_exporter' -p'lauzi$3)exporter' -e'SHOW DATABASES;'"
#do echo $i;
	#mysqldump --default-character-set=utf8 -u'lauzis_exporter' -p'lauzi$3)exporter' $i > db_$i.sql;
#done
