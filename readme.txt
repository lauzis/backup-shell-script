======================================
Backup Shell Script for using in cron
======================================

About
========================================
This bash shell skript is for backuping some (given) folders and mysql databases.
The folders ar arhived in tgz file with date in the file name.

All databases accessible by (given) user are stored in seperate files with date in the file name.


Use Cases
========================================
There are planty of backup tools, but wanted to create simple shell script to use it on my test server,
to add this in cron, that it would backup the important files and databases to different Raid 1 drive, just in case...
