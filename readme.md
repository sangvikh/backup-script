# Backup Script

This script performs full and incremental backups of specified directories to a designated backup location. It also includes functionality to clean up old backups, ensuring that storage space is managed efficiently.

## Features

- **Full and Incremental Backups**: Supports both full and incremental backups using `tar`.
- **Cleanup**: Automatically cleans up old backups based on a specified retention period.
- **Error Handling**: Prevents deletion of backups if the new backup fails.

## Requirements

- **Bash**: The script is written in Bash and requires a Unix-like environment to run.
- **Tar**: The script uses `tar` for creating backups.
- **Cron**: For scheduling regular backups.

## Usage

### Command Line Arguments

The script accepts one command line argument to specify the type of backup:

- `full`: Perform a full backup.
- `incremental`: Perform an incremental backup.

Example:

```bash
./backup_script.sh full
./backup_script.sh incremental
