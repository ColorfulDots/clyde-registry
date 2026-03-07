#!/bin/bash
# ============================================================
# Script Name:  wifi-password.sh
# Description:  Retrieves the password for the currently
#               connected Wi-Fi network from Keychain.
# Author:       colorfulDots
# Version:      1.0.0
# Installed at: ~/.clyde/user-scripts/wifi-password.sh
# ============================================================

SSID=$(networksetup -getairportnetwork en0 | awk -F': ' '{print $2}')

if [ -z "$SSID" ]; then
  echo "Not connected to any Wi-Fi network."
  exit 1
fi

echo "Network: $SSID"
PASSWORD=$(security find-generic-password -wa "$SSID" 2>/dev/null)

if [ -z "$PASSWORD" ]; then
  echo "Password not found in Keychain. You may need to approve access."
  exit 1
fi

echo "Password: $PASSWORD"
echo "$PASSWORD" | pbcopy
echo "(Copied to clipboard)"
