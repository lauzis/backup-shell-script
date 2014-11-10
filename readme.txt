======================================
Backup Shell Script for using in cron
======================================

About
========================================
This bash shell skript is for backuping some (given) folders and mysql databases.
The folders ar arhived in tgz file with date in the file name.

All databases accessible by (given) user are stored in seperate files with date in the file name.

Options
--------------------------------
-daily
Copies all the folders to the daily folder, makes dump of the database
Deletes backups older than  1 month (no need to keep each day older than that)

-weekly
If there is backup, then copies that to the weekly folder, deletes all weekly files
which are older than 3 monthes

-monthly
if there is backup, then coppies that to the monthly folder, deletes all backups from there older than year...


Use Cases
========================================
There are planty of backup tools, but wanted to create simple shell script to use it on my test server,
to add this in cron, that it would backup the important files and databases to different Raid 1 drive, just in case...


How to run scirpt
==================================================
Daily: copy everything, 
./server_backup.sh -daily
