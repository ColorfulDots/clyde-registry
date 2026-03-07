#!/bin/bash
# ============================================================
# Script Name:  clipboard-history.sh
# Description:  Maintains a rolling clipboard history log.
#               Run in watch mode to record, or search past
#               entries and copy one back to clipboard.
#               Replaces: Pastebot, Pasta, Clipboard Manager
# Author:       colorfulDots
# Version:      1.0.0
# Installed at: ~/.clyde/user-scripts/clipboard-history.sh
# Usage:        clipboard-history.sh [watch|search]
# ============================================================

HISTORY_FILE=~/.clyde/clipboard-history.txt
mkdir -p ~/.clyde
touch "$HISTORY_FILE"

MODE=${1:-search}

if [ "$MODE" = "watch" ]; then
  echo "📋 Watching clipboard... (Ctrl+C to stop)"
  LAST=""
  while true; do
    CURRENT=$(pbpaste)
    if [ "$CURRENT" != "$LAST" ] && [ -n "$CURRENT" ]; then
      TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
      echo "[$TIMESTAMP] $CURRENT" >> "$HISTORY_FILE"
      LAST="$CURRENT"
      echo "Saved: ${CURRENT:0:60}..."
    fi
    sleep 1
  done

elif [ "$MODE" = "search" ]; then
  if [ ! -s "$HISTORY_FILE" ]; then
    echo "No clipboard history yet. Run: clipboard-history.sh watch"
    exit 0
  fi

  echo "📋 Clipboard history (most recent first):"
  echo ""

  mapfile -t ENTRIES < <(tac "$HISTORY_FILE" | head -30)

  for i in "${!ENTRIES[@]}"; do
    echo "[$((i+1))] ${ENTRIES[$i]:0:80}"
  done

  echo ""
  read -p "Enter number to copy to clipboard (or Enter to quit): " CHOICE

  if [ -z "$CHOICE" ]; then
    exit 0
  fi

  INDEX=$((CHOICE - 1))
  # Strip the timestamp prefix
  TEXT=$(echo "${ENTRIES[$INDEX]}" | sed 's/^\[[^]]*\] //')
  echo -n "$TEXT" | pbcopy
  echo "✅ Copied to clipboard."
fi
