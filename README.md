Example:
```
backuppc:
  docker: true
  docker_image: 'backuppc'
  docker_images_tag: 'latest'
  docker_port: 80
  base_path: '/tmp'
  hosts:
    - host: '192.168.88.15'
      user: 'makky'
      moreusers:
        - 1
        - 2
      compress_level: 6
      rsyncsharename:
        - /tmp
        - /var/tmp 
#      type [rsync|tar]
      xfer_method: 'rsync'
#      BackupFilesOnly
#      DumpPreUserCmd
#      DumpPostUserCmd
    - host: '192.168.88.16'
      user: 'makky1'
```

For backup database recomended create dump and copy to backup server:

1. Override the “DumpPreUserCmd
```
$sshPath -q -x -l backuppc $host /var/backup/backup.sh
```

```
GRANT USAGE ON *.* TO backup@localhost IDENTIFIED BY 'pas$wr0d';
GRANT SELECT,LOCK TABLES ON your_database.* to backup@localhost;
FLUSH PRIVILEGES;
```
```
sudo -u backup bash
cd
cat > ~/.my.cnf << EOF
[mysqldump]
user = backup
password = passwordgoeshere
EOF
```

```
chmod og= .my.cnf
```

```
sudo -u backup bash
cd
mysqldump -u backup -h localhost --single-transaction your_database | gzip > test.sql.gz
```
