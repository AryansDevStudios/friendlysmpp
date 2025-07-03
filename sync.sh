#!/bin/bash

echo "[INFO] $(date) - Starting sync"
git pull
git add .
git commit -m "Auto-sync $(date '+%Y-%m-%d %H:%M:%S')"
git push origin master
echo "[INFO] $(date) - Sync complete"