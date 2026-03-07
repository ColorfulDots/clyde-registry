#!/bin/bash
# ============================================================
# Script Name:  daily-backup.sh
# Description:  Creates a timestamped zip backup of a folder
#               and saves it to ~/Backups.
#               Usage: daily-backup.sh ~/Documents/my-project
# Author:       colorfulDots
# Version:      1.0.0
# Installed at: ~/.clyde/user-scripts/daily-backup.sh
# ============================================================

SOURCE=$1

if [ -z "$SOURCE" ]; then
  echo "Usage: daily-backup.sh <folder-to-backup>"
  exit 1
fi

if [ ! -d "$SOURCE" ]; then
  echo "Source folder not found: $SOURCE"
  exit 1
fi

BACKUP_DIR=~/Backups
mkdir -p "$BACKUP_DIR"

BASENAME=$(basename "$SOURCE")
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')
OUTPUT="$BACKUP_DIR/${BASENAME}_${TIMESTAMP}.zip"

echo "Backing up $SOURCE..."
zip -rq "$OUTPUT" "$SOURCE"
echo "Backup saved to: $OUTPUT"
