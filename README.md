Finally, we have to tell BackupPC what to do with this file. Go to your host and edit the config. At “Xfer => RsyncShareName”, simply add the “/var/backup” directory. In “Backup Settings”, override the “DumpPreUserCmd

$sshPath -q -x -l backuppc $host /var/backup/backup.sh

GRANT USAGE ON *.* TO backup@localhost IDENTIFIED BY 'passwordgoeshere';
GRANT SELECT,LOCK TABLES ON your_database.* to backup@localhost;
FLUSH PRIVILEGES;

sudo -u backup bash
cd
cat > ~/.my.cnf << EOF
[mysqldump]
user = backup
password = passwordgoeshere
EOF
chmod og= .my.cnf

sudo -u backup bash
cd
mysqldump -u backup -h localhost --single-transaction your_database | gzip > test.sql.gz

