#!/bin/bash
# ============================================================
# Script Name:  resize-images.sh
# Description:  Resizes all JPG and PNG images in a folder
#               to a max width using sips (built into macOS).
#               Usage: resize-images.sh ~/Desktop/photos 1200
# Author:       colorfulDots
# Version:      1.0.0
# Installed at: ~/.clyde/user-scripts/resize-images.sh
# ============================================================

FOLDER=$1
MAX_WIDTH=${2:-1200}

if [ -z "$FOLDER" ]; then
  echo "Usage: resize-images.sh <folder> [max-width]"
  exit 1
fi

if [ ! -d "$FOLDER" ]; then
  echo "Folder not found: $FOLDER"
  exit 1
fi

COUNT=0
for FILE in "$FOLDER"/*.{jpg,jpeg,png,JPG,JPEG,PNG}; do
  [ -f "$FILE" ] || continue
  sips --resampleWidth "$MAX_WIDTH" "$FILE" --out "$FILE" > /dev/null 2>&1
  echo "Resized: $FILE"
  COUNT=$((COUNT + 1))
done

echo "Done. $COUNT image(s) resized to max width $MAX_WIDTH px."
