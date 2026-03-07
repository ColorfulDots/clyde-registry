#!/bin/bash
# ============================================================
# Script Name:  git-branch-cleanup.sh
# Description:  Deletes all local Git branches that have
#               already been merged into main or master.
# Author:       colorfulDots
# Version:      1.0.0
# Installed at: ~/.clyde/user-scripts/git-branch-cleanup.sh
# ============================================================

DEFAULT_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')

if [ -z "$DEFAULT_BRANCH" ]; then
  DEFAULT_BRANCH="main"
fi

echo "Cleaning up merged branches against '$DEFAULT_BRANCH'..."

MERGED=$(git branch --merged "$DEFAULT_BRANCH" | grep -v "^\*" | grep -v "$DEFAULT_BRANCH")

if [ -z "$MERGED" ]; then
  echo "No merged branches to clean up."
  exit 0
fi

echo "The following branches will be deleted:"
echo "$MERGED"
echo ""
read -p "Continue? (y/n) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "$MERGED" | xargs git branch -d
  echo "Done."
else
  echo "Aborted."
fi
