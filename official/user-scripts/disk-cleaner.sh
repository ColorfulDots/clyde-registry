#!/bin/bash
# ============================================================
# Script Name:  disk-cleaner.sh
# Description:  Deep cleans your Mac — caches, logs, trash,
#               Xcode derived data, and Homebrew in one shot.
#               Replaces: CleanMyMac, CCleaner
# Author:       colorfulDots
# Version:      1.0.0
# Installed at: ~/.clyde/user-scripts/disk-cleaner.sh
# ============================================================

FREED=0

bytes_free() {
  df / | tail -1 | awk '{print $4}'
}

BEFORE=$(bytes_free)

echo "🧹 Starting deep clean..."
echo ""

# User caches
echo "→ Clearing user caches..."
rm -rf ~/Library/Caches/* 2>/dev/null
echo "  Done."

# System logs
echo "→ Clearing user logs..."
rm -rf ~/Library/Logs/* 2>/dev/null
echo "  Done."

# Xcode derived data
if [ -d ~/Library/Developer/Xcode/DerivedData ]; then
  echo "→ Clearing Xcode DerivedData..."
  rm -rf ~/Library/Developer/Xcode/DerivedData/* 2>/dev/null
  echo "  Done."
fi

# Xcode simulator caches
if [ -d ~/Library/Developer/CoreSimulator/Caches ]; then
  echo "→ Clearing Xcode Simulator caches..."
  rm -rf ~/Library/Developer/CoreSimulator/Caches/* 2>/dev/null
  echo "  Done."
fi

# Homebrew
if command -v brew &>/dev/null; then
  echo "→ Running brew cleanup..."
  brew cleanup -q 2>/dev/null
  echo "  Done."
fi

# npm cache
if command -v npm &>/dev/null; then
  echo "→ Clearing npm cache..."
  npm cache clean --force -q 2>/dev/null
  echo "  Done."
fi

# Trash
echo "→ Emptying Trash..."
osascript -e 'tell application "Finder" to empty trash' 2>/dev/null
echo "  Done."

AFTER=$(bytes_free)
DIFF=$(( (AFTER - BEFORE) * 512 / 1024 / 1024 ))

echo ""
echo "✅ Clean complete. Approx ${DIFF}MB freed."
