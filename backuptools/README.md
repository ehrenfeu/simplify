Installation Instructions
=========================

Basic setup
-----------
Set up the generic parts of the backuptools
```
TOOLSREPO="/opt/simplify/backuptools"

mkdir -pv ~/bin
cd ~/bin
ln -s ${TOOLSREPO}/run-backup-control.sh

mkdir -pv ~/.backuptools
cd ~/.backuptools
ln -s ${TOOLSREPO}/functions.inc.sh
ln -s ${TOOLSREPO}/inc

mkdir -pv ~/.backuptools/configs
cp -v ${TOOLSREPO}/configs/COMMON.template ~/.backuptools/configs/COMMON
vim ~/.backuptools/configs/COMMON

source ~/.backuptools/configs/COMMON
mkdir -pv "${BAKDIR}"
```

Cron execution
--------------
Add something like this to your crontab (e.g. via `crontab -e`). Please note
that so far *NOTHING* is backed up yet, as no plugins have been configured!
```
45 2 * * *      $HOME/bin/run-backup-control.sh 2>&1 | mailx -E -s "Backup Control - $(cat /etc/hostname)" $LOGNAME
```

NOTE: by using the pipe to `mailx` you are able to specify how the mail
subject is looking. You can omit this, then it will use the default cron
format. The sender name will be taken from `/etc/passwd` corresponding to the
name specified for the account running the job.

MySQL dumps
-----------

Configure the mysql backup script:
```
mkdir -pv ~/.backuptools/backup.d && cd ~/.backuptools/backup.d
ln -s ${TOOLSREPO}/backup.d/mysqldump-complete.sh
cp -v ${TOOLSREPO}/configs/mysqldump-complete.template ~/.backuptools/configs/mysqldump-complete
chmod go-rwx ~/.backuptools/configs/mysqldump-complete
vim ~/.backuptools/configs/mysqldump-complete
```

Create a backup user in MySQL (see
http://dev.mysql.com/doc/mysql-enterprise-backup/3.10/en/mysqlbackup.privileges.html
for details)
```
source ~/.backuptools/configs/mysqldump-complete

echo "CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PW';
GRANT RELOAD ON *.* TO '$DB_USER'@'localhost';
GRANT CREATE, INSERT, DROP, UPDATE ON mysql.backup_progress TO '$DB_USER'@'localhost';
GRANT CREATE, INSERT, SELECT, DROP, UPDATE ON mysql.backup_history TO '$DB_USER'@'localhost';
GRANT REPLICATION CLIENT ON *.* TO '$DB_USER'@'localhost';
GRANT SUPER ON *.* TO '$DB_USER'@'localhost';
GRANT LOCK TABLES, SELECT, CREATE, ALTER ON *.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;" | mysql -u root -p
```

In case MySQL is complaining about the mysql.event table, adjust the MySQL
config to skip it during a dump. Add the following entry to the `[mysqldump]`
section of `/etc/mysql/my.cnf`:

```
ignore-table=mysql.event
```

Rsync
-----
```
mkdir -pv ~/.backuptools/backup.d && cd ~/.backuptools/backup.d
ln -s ${TOOLSREPO}/backup.d/rsync.sh
cp -v ${TOOLSREPO}/configs/rsync.template ~/.backuptools/configs/rsync
chmod go-rwx ~/.backuptools/configs/rsync
vim ~/.backuptools/configs/rsync
```

Restricted Rsync
----------------
```
gunzip /usr/share/doc/rsync/scripts/rrsync.gz -c > ~/bin/rrsync
sudo cp -v ~/bin/rrsync /usr/local/bin/rrsync
sudo chmod +x /usr/local/bin/rrsync
sudo ln -sv /usr/local/bin/rrsync /usr/bin/
rm ~/bin/rrsync
```
