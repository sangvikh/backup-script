#!/bin/bash
####################################
#
# Backup to NFS mount script with incremental backup support and cleanup.
#
####################################

# Check if backup type is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 [full|incremental]"
    exit 1
fi

# What to backup.
backup_files="/home /var/spool/mail /etc /root /boot /opt"

# Where to backup to.
dest="/mnt/backup"

# Create archive filename.
day=$(date +%A)
hostname=$(hostname -s)
archive_file="$hostname-$day.tgz"

# Snapshot file for incremental backups
snapshot_file="$dest/$hostname.snar"

# Number of days to keep backups
keep_days=30

# Print start status message.
echo "Backing up $backup_files to $dest/$archive_file"
date
echo

# Backup the files using tar.
if [ "$1" == "full" ]; then
    echo "Performing full backup..."
    tar --create --gzip --file "$dest/$archive_file" --listed-incremental="$snapshot_file" $backup_files
elif [ "$1" == "incremental" ]; then
    echo "Performing incremental backup..."
    tar --create --gzip --file "$dest/$archive_file" --listed-incremental="$snapshot_file" $backup_files
else
    echo "Invalid argument. Use 'full' or 'incremental'."
    exit 1
fi

# Check if backup was successful
if [ $? -eq 0 ]; then
    echo "Backup successful."
else
    echo "Backup failed. Skipping cleanup."
    exit 1
fi

# Print end status message.
echo
echo "Backup finished"
date

# Long listing of files in $dest to check file sizes.
ls -lh $dest

# Cleanup old backups
echo "Cleaning up backups older than $keep_days days..."
find "$dest" -name "*.tgz" -type f -mtime +$keep_days -delete

echo "Cleanup finished"
