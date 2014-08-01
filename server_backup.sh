#!/bin/bash

echo "Starting backup!" | mail -s "[itdep412] Starting backup!" $notify_email

settingsfile='bk_settings.cfg';

#checks if settings file exists if not exits
if [ -f "$settingsfile" ] 
then
	source $settingsfile
else
	echo Settings file $settingsfile not found... can not continue...
	exit
fi


echo $current_date;
echo $1;
case $1 in
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
for i in `mysql -u lauzis_exporter -p'lauzi$3)exporter' -e'SHOW DATABASES;' | egrep -v 'information_schema|performance_schema|Database'`; 
do 
	echo /media/backup/daily/db/db_$current_date.$i.sql;
	mysqldump --default-character-set=utf8 -u lauzis_exporter -p'lauzi$3)exporter' $i > /media/backup/daily/db/db_$current_date.$i.sql; 
	gzip -9f /media/backup/daily/db/db_$current_date.$i.sql;
	case $1 in
		-weekly) cp /media/backup/daily/db/db_$current_date.$i.sql.gz /media/backup/weekly/db/;;
		-monthly) cp /media/backup/daily/db/db_$current_date.$i.sql.gz /media/backup/monthly/db/;;
	esac
done

echo "Informing that backup is finished" | mail -s "[itdep412] Finished backup" $notify_email




#for i in "mysql -u'lauzis_exporter' -p'lauzi$3)exporter' -e'SHOW DATABASES;'"
#do echo $i;
	#mysqldump --default-character-set=utf8 -u'lauzis_exporter' -p'lauzi$3)exporter' $i > db_$i.sql;
#done
