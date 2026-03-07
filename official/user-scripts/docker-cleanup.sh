#!/bin/bash
# ============================================================
# Script Name:  docker-cleanup.sh
# Description:  Removes stopped containers, dangling images,
#               unused volumes, and build cache.
# Author:       colorfulDots
# Version:      1.0.0
# Installed at: ~/.clyde/user-scripts/docker-cleanup.sh
# ============================================================

echo "Stopping all running containers..."
RUNNING=$(docker ps -q)
if [ -n "$RUNNING" ]; then
  docker stop $RUNNING
else
  echo "No running containers."
fi

echo ""
echo "Removing stopped containers..."
docker container prune -f

echo ""
echo "Removing dangling images..."
docker image prune -f

echo ""
echo "Removing unused volumes..."
docker volume prune -f

echo ""
echo "Removing build cache..."
docker builder prune -f

echo ""
echo "Docker cleanup complete."
docker system df
