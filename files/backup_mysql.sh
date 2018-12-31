#!//bin/bash
# Some variables - adjust them as needed
BACKUP_DIR=/var/backup
MYSQL_USER=backup
N=8

# Do backups
cd $BACKUP_DIR

# Get all databases
databases=`mysql -u $MYSQL_USER -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema|test)"`

# Perform Backup for each database
for db in $databases; do

        # Check whether the directory already exists. If not, create it
        if [ ! -d "$BACKUP_DIR/$db" ]; then
                mkdir $BACKUP_DIR/$db
        fi

        # Backup DB
        FILENAME=$BACKUP_DIR/$db/`date "+%Y%m%d.%H%M%S"`.sql.gz
        mysqldump -u $MYSQL_USER -h localhost $db | gzip > $FILENAME
        # Adjust permissions
        chmod og= $FILENAME

        # Delete backups older than $N days
        find $BACKUP_DIR/$db -name "*.sql.gz" | sort -r | tail -n +$N | xargs rm -f
done