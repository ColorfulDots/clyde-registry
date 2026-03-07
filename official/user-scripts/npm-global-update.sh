#!/bin/bash
# ============================================================
# Script Name:  npm-global-update.sh
# Description:  Lists and updates all globally installed
#               npm packages to their latest versions.
# Author:       colorfulDots
# Version:      1.0.0
# Installed at: ~/.clyde/user-scripts/npm-global-update.sh
# ============================================================

echo "Checking globally installed npm packages..."
npm list -g --depth=0

echo ""
echo "Updating all global packages..."
npm update -g

echo ""
echo "Done. Updated packages:"
npm list -g --depth=0
