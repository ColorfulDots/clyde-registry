#!/bin/bash
# ============================================================
# Script Name:  transform-clipboard.sh
# Description:  Transforms clipboard text — trim, uppercase,
#               lowercase, slugify, strip HTML, encode URL,
#               and more. No TextSoap needed.
#               Replaces: TextSoap, Transformer, text editors
# Author:       colorfulDots
# Version:      1.0.0
# Installed at: ~/.clyde/user-scripts/transform-clipboard.sh
# Usage:        transform-clipboard.sh [transform]
# ============================================================

TEXT=$(pbpaste)

if [ -z "$TEXT" ]; then
  echo "Clipboard is empty."
  exit 1
fi

TRANSFORMS=(
  "uppercase"
  "lowercase"
  "titlecase"
  "trim whitespace"
  "slugify"
  "strip HTML tags"
  "encode for URL"
  "decode URL"
  "reverse"
  "count characters"
)

if [ -z "$1" ]; then
  echo "📋 Current clipboard: \"${TEXT:0:60}...\""
  echo ""
  echo "Choose a transform:"
  for i in "${!TRANSFORMS[@]}"; do
    echo "[$((i+1))] ${TRANSFORMS[$i]}"
  done
  echo ""
  read -p "Enter number: " CHOICE
  INDEX=$((CHOICE - 1))
  TRANSFORM="${TRANSFORMS[$INDEX]}"
else
  TRANSFORM="$1"
fi

case "$TRANSFORM" in
  "uppercase")
    RESULT=$(echo "$TEXT" | tr '[:lower:]' '[:upper:]') ;;
  "lowercase")
    RESULT=$(echo "$TEXT" | tr '[:upper:]' '[:lower:]') ;;
  "titlecase")
    RESULT=$(echo "$TEXT" | python3 -c "import sys; print(sys.stdin.read().title().strip())") ;;
  "trim whitespace")
    RESULT=$(echo "$TEXT" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//') ;;
  "slugify")
    RESULT=$(echo "$TEXT" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//;s/-$//') ;;
  "strip HTML tags")
    RESULT=$(echo "$TEXT" | sed 's/<[^>]*>//g') ;;
  "encode for URL")
    RESULT=$(python3 -c "import urllib.parse, sys; print(urllib.parse.quote(sys.stdin.read().strip()))" <<< "$TEXT") ;;
  "decode URL")
    RESULT=$(python3 -c "import urllib.parse, sys; print(urllib.parse.unquote(sys.stdin.read().strip()))" <<< "$TEXT") ;;
  "reverse")
    RESULT=$(echo "$TEXT" | rev) ;;
  "count characters")
    COUNT=$(echo -n "$TEXT" | wc -c | tr -d ' ')
    WORDS=$(echo "$TEXT" | wc -w | tr -d ' ')
    echo "Characters: $COUNT"
    echo "Words: $WORDS"
    exit 0 ;;
  *)
    echo "Unknown transform: $TRANSFORM"
    exit 1 ;;
esac

echo -n "$RESULT" | pbcopy
echo "✅ Transformed ($TRANSFORM) and copied to clipboard."
echo "   Preview: \"${RESULT:0:80}\""
