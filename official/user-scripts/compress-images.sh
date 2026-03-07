#!/bin/bash
# ============================================================
# Script Name:  compress-images.sh
# Description:  Batch compresses JPG and PNG images in a
#               folder using macOS built-in sips. No
#               ImageOptim or external tools needed.
#               Replaces: ImageOptim, Squash, Compressor.io
# Author:       colorfulDots
# Version:      1.0.0
# Installed at: ~/.clyde/user-scripts/compress-images.sh
# Usage:        compress-images.sh <folder> [quality 1-100]
# ============================================================

FOLDER=$1
QUALITY=${2:-75}

if [ -z "$FOLDER" ]; then
  echo "Usage: compress-images.sh <folder> [quality]"
  echo "  quality: 1-100 (default 75)"
  exit 1
fi

if [ ! -d "$FOLDER" ]; then
  echo "Folder not found: $FOLDER"
  exit 1
fi

COUNT=0
SAVED=0

for FILE in "$FOLDER"/*.{jpg,jpeg,png,JPG,JPEG,PNG}; do
  [ -f "$FILE" ] || continue

  BEFORE=$(stat -f%z "$FILE")
  sips --setProperty formatOptions "$QUALITY" "$FILE" --out "$FILE" > /dev/null 2>&1
  AFTER=$(stat -f%z "$FILE")

  DIFF=$(( (BEFORE - AFTER) / 1024 ))
  SAVED=$((SAVED + DIFF))
  COUNT=$((COUNT + 1))
  echo "Compressed: $(basename "$FILE") (saved ~${DIFF}KB)"
done

if [ "$COUNT" -eq 0 ]; then
  echo "No images found in $FOLDER"
else
  echo ""
  echo "✅ $COUNT image(s) compressed. Total saved: ~${SAVED}KB"
fi
