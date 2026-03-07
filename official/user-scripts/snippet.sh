#!/bin/bash
# ============================================================
# Script Name:  snippet.sh
# Description:  Save, search, and copy code snippets from a
#               local plaintext library at ~/.clyde/snippets/.
#               Replaces: SnippetsLab, Codepoint, massCode
# Author:       colorfulDots
# Version:      1.0.0
# Installed at: ~/.clyde/user-scripts/snippet.sh
# Usage:        snippet.sh [save|search|list]
# ============================================================

SNIPPETS_DIR=~/.clyde/snippets
mkdir -p "$SNIPPETS_DIR"

MODE=${1:-search}

if [ "$MODE" = "save" ]; then
  TEXT=$(pbpaste)
  if [ -z "$TEXT" ]; then
    echo "Clipboard is empty. Copy a snippet first."
    exit 1
  fi

  read -p "Snippet name (e.g. react-useeffect): " NAME
  if [ -z "$NAME" ]; then
    echo "Name required."
    exit 1
  fi

  read -p "Tags (comma separated, e.g. react,hooks): " TAGS
  read -p "Language (e.g. js, python, bash): " LANG

  FILE="$SNIPPETS_DIR/${NAME}.snip"
  {
    echo "# name: $NAME"
    echo "# tags: $TAGS"
    echo "# lang: $LANG"
    echo "# saved: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "---"
    echo "$TEXT"
  } > "$FILE"

  echo "✅ Snippet saved: $FILE"

elif [ "$MODE" = "list" ]; then
  FILES=("$SNIPPETS_DIR"/*.snip)
  if [ ! -f "${FILES[0]}" ]; then
    echo "No snippets saved yet. Run: snippet.sh save"
    exit 0
  fi
  echo "📚 Saved snippets:"
  for f in "${FILES[@]}"; do
    NAME=$(basename "$f" .snip)
    TAGS=$(grep "^# tags:" "$f" | sed 's/# tags: //')
    LANG=$(grep "^# lang:" "$f" | sed 's/# lang: //')
    echo "  $NAME  [$LANG]  $TAGS"
  done

elif [ "$MODE" = "search" ]; then
  read -p "Search snippets: " QUERY

  mapfile -t MATCHES < <(grep -rl "$QUERY" "$SNIPPETS_DIR" 2>/dev/null)

  if [ ${#MATCHES[@]} -eq 0 ]; then
    echo "No snippets found for: $QUERY"
    exit 0
  fi

  echo ""
  echo "Found ${#MATCHES[@]} snippet(s):"
  for i in "${!MATCHES[@]}"; do
    NAME=$(basename "${MATCHES[$i]}" .snip)
    TAGS=$(grep "^# tags:" "${MATCHES[$i]}" | sed 's/# tags: //')
    echo "[$((i+1))] $NAME  [$TAGS]"
  done

  echo ""
  read -p "Enter number to copy to clipboard (or Enter to quit): " CHOICE
  if [ -z "$CHOICE" ]; then exit 0; fi

  INDEX=$((CHOICE - 1))
  CONTENT=$(sed -n '/^---$/,$ p' "${MATCHES[$INDEX]}" | tail -n +2)
  echo -n "$CONTENT" | pbcopy
  echo "✅ Snippet copied to clipboard."
fi
