#!/bin/bash
####################################
#
# Backup to NFS mount script with
# grandparent-parent-child rotation.
#
####################################

# What to backup.
backup_files="/home /var/spool/mail /etc /root /boot /opt"

# Where to backup to.
dest="/mnt/backup"

# Setup variables for the archive filename.
day=$(date +%A)
hostname=$(hostname -s)

# Find which week of the month 1-4 it is.
day_num=$(date +%-d)
if (( $day_num <= 7 )); then
        week_file="$hostname-week1.tgz"
elif (( $day_num > 7 && $day_num <= 14 )); then
        week_file="$hostname-week2.tgz"
elif (( $day_num > 14 && $day_num <= 21 )); then
        week_file="$hostname-week3.tgz"
elif (( $day_num > 21 && $day_num < 32 )); then
        week_file="$hostname-week4.tgz"
fi

# Find if the Month is odd or even.
month_num=$(date +%m)
month=$(expr $month_num % 2)
if [ $month -eq 0 ]; then
        month_file="$hostname-month2.tgz"
else
        month_file="$hostname-month1.tgz"
fi

# Create archive filename.
if [ $day_num == 1 ]; then
        archive_file=$month_file
elif [ $day != "Saturday" ]; then
        archive_file="$hostname-$day.tgz"
else
        archive_file=$week_file
fi

# Snapshot file for incremental backups
snapshot_file="$dest/$hostname.snar"

# Print start status message.
echo "Backing up $backup_files to $dest/$archive_file"
date
echo

# Backup the files using tar.
if [ $day_num == 1 ]; then
    echo "Performing full backup..."
    tar --create --gzip --file "$dest/$archive_file" --listed-incremental="$snapshot_file" $backup_files
else
    echo "Performing incremental backup..."
    tar --create --gzip --file "$dest/$archive_file" --listed-incremental="$snapshot_file" $backup_files
fi

# Check if backup was successful
if [ $? -eq 0 ]; then
    echo "Backup successful."
else
    echo "Backup failed."
    exit 1
fi

# Print end status message.
echo
echo "Backup finished"
date

# Long listing of files in $dest to check file sizes.
ls -lh $dest
