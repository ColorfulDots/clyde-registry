#!/bin/bash
# ============================================================
# Script Name:  caffeinate.sh
# Description:  Keeps your Mac awake for a specified duration,
#               then sends a notification when done.
#               Replaces: Lungo, Amphetamine, Caffeine
# Author:       colorfulDots
# Version:      1.0.0
# Installed at: ~/.clyde/user-scripts/caffeinate.sh
# Usage:        caffeinate.sh [minutes]
# ============================================================

MINUTES=${1:-60}
SECONDS_TOTAL=$((MINUTES * 60))

echo "☕ Keeping Mac awake for $MINUTES minute(s)..."
echo "   Press Ctrl+C to cancel early."

caffeinate -d -t "$SECONDS_TOTAL" &
PID=$!

# Trap Ctrl+C to kill caffeinate cleanly
trap "kill $PID 2>/dev/null; echo ''; echo 'Caffeinate cancelled.'; exit 0" INT

wait $PID

osascript -e "display notification \"Your Mac is allowed to sleep again.\" with title \"Caffeinate Done\" sound name \"Glass\""
echo "✅ Done. Mac can sleep again."
