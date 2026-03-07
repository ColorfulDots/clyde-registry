#!/bin/bash
# ============================================================
# Script Name:  clear-xcode-cache.sh
# Description:  Clears Xcode DerivedData, Archives, and
#               simulator caches to free up disk space.
# Author:       colorfulDots
# Version:      1.0.0
# Installed at: ~/.clyde/user-scripts/clear-xcode-cache.sh
# ============================================================

echo "Clearing Xcode caches..."

DERIVED="$HOME/Library/Developer/Xcode/DerivedData"
ARCHIVES="$HOME/Library/Developer/Xcode/Archives"
SIM_CACHE="$HOME/Library/Developer/CoreSimulator/Caches"

for DIR in "$DERIVED" "$SIM_CACHE"; do
  if [ -d "$DIR" ]; then
    rm -rf "$DIR"
    echo "Cleared: $DIR"
  fi
done

echo ""
echo "Note: Archives at $ARCHIVES were left intact."
echo "Done. You may want to restart Xcode."
