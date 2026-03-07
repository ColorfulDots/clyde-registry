#!/bin/bash
# ============================================================
# Script Name:  kill-port.sh
# Description:  Kills the process running on a given port.
#               Usage: kill-port.sh 3000
# Author:       colorfulDots
# Version:      1.0.0
# Installed at: ~/.clyde/user-scripts/kill-port.sh
# ============================================================

PORT=$1

if [ -z "$PORT" ]; then
  echo "Usage: kill-port.sh <port>"
  exit 1
fi

PID=$(lsof -ti :"$PORT")

if [ -z "$PID" ]; then
  echo "No process found on port $PORT."
  exit 0
fi

echo "Killing process $PID on port $PORT..."
kill -9 "$PID"
echo "Done."
