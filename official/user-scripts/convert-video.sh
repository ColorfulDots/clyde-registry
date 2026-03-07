#!/bin/bash
# ============================================================
# Script Name:  convert-video.sh
# Description:  Converts a video file to mp4 or gif using
#               ffmpeg. No HandBrake or Permute needed.
#               Replaces: Permute, HandBrake, GIF Brewery
# Author:       colorfulDots
# Version:      1.0.0
# Installed at: ~/.clyde/user-scripts/convert-video.sh
# Usage:        convert-video.sh <input-file> [mp4|gif] [width]
# ============================================================

INPUT=$1
FORMAT=${2:-mp4}
WIDTH=${3:-1280}

if [ -z "$INPUT" ]; then
  echo "Usage: convert-video.sh <input-file> [mp4|gif] [width]"
  echo "  mp4  — re-encode to H.264 mp4 (default)"
  echo "  gif  — convert to optimized GIF"
  exit 1
fi

if [ ! -f "$INPUT" ]; then
  echo "File not found: $INPUT"
  exit 1
fi

if ! command -v ffmpeg &>/dev/null; then
  echo "ffmpeg is required. Install with: brew install ffmpeg"
  exit 1
fi

BASENAME="${INPUT%.*}"

if [ "$FORMAT" = "gif" ]; then
  OUTPUT="${BASENAME}.gif"
  echo "🎬 Converting to GIF (width: ${WIDTH}px)..."
  ffmpeg -i "$INPUT" -vf "fps=15,scale=${WIDTH}:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" \
    -loop 0 "$OUTPUT" -y -loglevel error
else
  OUTPUT="${BASENAME}_converted.mp4"
  echo "🎬 Converting to MP4 (width: ${WIDTH}px)..."
  ffmpeg -i "$INPUT" -vf "scale=${WIDTH}:-2" -c:v libx264 -crf 23 -preset fast \
    -c:a aac -b:a 128k "$OUTPUT" -y -loglevel error
fi

echo "✅ Done: $OUTPUT"
