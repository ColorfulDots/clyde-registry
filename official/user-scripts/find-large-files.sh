#!/bin/bash
# ============================================================
# Script Name:  find-large-files.sh
# Description:  Finds the 20 largest files on your Mac,
#               lets you inspect and optionally delete them.
#               Replaces: DaisyDisk, GrandPerspective
# Author:       colorfulDots
# Version:      1.0.0
# Installed at: ~/.clyde/user-scripts/find-large-files.sh
# Usage:        find-large-files.sh [search-path]
# ============================================================

SEARCH=${1:-$HOME}

echo "🔍 Finding 20 largest files in $SEARCH..."
echo "(This may take a moment)"
echo ""

mapfile -t FILES < <(find "$SEARCH" -type f -not -path "*/\.*" 2>/dev/null \
  | xargs du -sh 2>/dev/null \
  | sort -rh \
  | head -20 \
  | awk '{print $1 "\t" $2}')

if [ ${#FILES[@]} -eq 0 ]; then
  echo "No files found."
  exit 0
fi

for i in "${!FILES[@]}"; do
  echo "[$((i+1))] ${FILES[$i]}"
done

echo ""
read -p "Enter number to delete (or press Enter to quit): " CHOICE

if [ -z "$CHOICE" ]; then
  echo "Exiting."
  exit 0
fi

INDEX=$((CHOICE - 1))
FILEPATH=$(echo "${FILES[$INDEX]}" | awk '{print $2}')

if [ -z "$FILEPATH" ]; then
  echo "Invalid selection."
  exit 1
fi

read -p "Delete '$FILEPATH'? This cannot be undone. (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
  rm -rf "$FILEPATH"
  echo "Deleted: $FILEPATH"
else
  echo "Aborted."
fi
