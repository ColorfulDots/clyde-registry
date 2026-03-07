#!/bin/bash
# ============================================================
# Script Name:  record-screen.sh
# Description:  Records your screen to an mp4 file using
#               macOS built-in screencapture. No Screenium,
#               Loom, or Kap needed for quick recordings.
#               Replaces: Screenium, Kap, ScreenFloat
# Author:       colorfulDots
# Version:      1.0.0
# Installed at: ~/.clyde/user-scripts/record-screen.sh
# Usage:        record-screen.sh [output-file]
# ============================================================

TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')
OUTPUT=${1:-~/Desktop/recording_${TIMESTAMP}.mp4}

echo "🎥 Screen recording will start in 3 seconds..."
echo "   Output: $OUTPUT"
echo "   Press Ctrl+C to stop recording."
echo ""
sleep 3

# Start recording — screencapture -V records video
screencapture -V "$OUTPUT" &
REC_PID=$!

trap "kill $REC_PID 2>/dev/null; echo ''; echo '⏹  Recording stopped.'; exit 0" INT

echo "⏺  Recording... (Ctrl+C to stop)"
wait $REC_PID

if [ -f "$OUTPUT" ]; then
  SIZE=$(du -sh "$OUTPUT" | awk '{print $1}')
  echo "✅ Saved: $OUTPUT ($SIZE)"

  read -p "Open in QuickTime? (y/n) " -n 1 -r
  echo ""
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    open -a QuickTime\ Player "$OUTPUT"
  fi
else
  echo "Recording was cancelled or failed."
fi
