======================================
Backup Shell Script for using in cron
======================================

About
========================================
This bash shell skript is for backuping some (given) folders and accessible (for givven user) mysql databases.
The folders ar arhived in tgz file with date in the file name.
All databases accessible by (given) user are stored in seperate files with date in the file name.

Options
--------------------------------
-daily
Copies all the folders to the daily folder, makes dump of the database
Deletes backups older than  1 month (no need to keep each day older than that)

-weekly
If there is backup, then copies that to the weekly folder, deletes all weekly files
which are older than 6 monthes...
so we store six month of backup files by week

-monthly
if there is backup, then coppies that to the monthly folder, deletes all backups from there older than 1.5 year...
So we store 1.5 years backup by each month...


Use Cases
========================================
There are planty of backup tools, but wanted to create simple shell script to use it on my test server,
to add this in cron, that it would backup the important files and databases to different raid 1 drive.


How to run scirpt
==================================================
Daily:
Should be run once per day.
This will delete all old files (older than 1 month) from daily backup folder, then copies all (given) folders to daily folder and dumps all accessible databases to seperate folders
./server_backup.sh
OR
./server_backup.sh -daily

Weekly:
This should be run once a weeek, will delete old files from weekly folder, then does same stuff as daily, but coppies that to weekly folder...
So if you dont need daily backups, you can use this instead.
./server_backup.sh -weekly

Monthly:
This should be run once month, will delete old files from monthly folder, then does same stuff as daily, but coppies data to monthly folder...
./server_backup.sh -monthly


Cron tasks
==============================

#daily
@daily /path/to/script/server_backup.sh -daily
#weekly
@weekly /path/to/script/server_backup.sh -weekly
#montly
@monthly /path/to/script/server_backup.sh -monthly

OR

#two o'clock at night
0 2 * * * /path/to/script/server_backup.sh -daily
#at given dates (after 7 days) at threee o'clock at night
0 3 1,8,15,22,29 * * /path/to/script/server_backup.sh -weekly
#each mohtn 2 date at three o'clock
0 3 2 * * /path/to/script/server_backup.sh -monthly


