#!/bin/bash
# ============================================================
# Script Name:  new-project.sh
# Description:  Scaffolds a new project folder with a git repo,
#               README, .gitignore, and opens it in VS Code.
#               Usage: new-project.sh my-project-name
# Author:       colorfulDots
# Version:      1.0.0
# Installed at: ~/.clyde/user-scripts/new-project.sh
# ============================================================

NAME=$1

if [ -z "$NAME" ]; then
  echo "Usage: new-project.sh <project-name>"
  exit 1
fi

TARGET=~/Projects/$NAME

if [ -d "$TARGET" ]; then
  echo "Directory $TARGET already exists."
  exit 1
fi

echo "Creating project at $TARGET..."
mkdir -p "$TARGET"
cd "$TARGET" || exit 1

git init
echo "# $NAME" > README.md
echo "node_modules/\n.DS_Store\n.env\ndist/" > .gitignore
git add .
git commit -m "Initial commit"

echo "Done. Opening in VS Code..."
code "$TARGET"
