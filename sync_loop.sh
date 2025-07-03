#!/bin/bash

cd /home/friendlysmpp

while true; do
    # sync >> ~/sync.log 2>&1
    echo "[INFO] $(date) - Starting sync"
    git add .
    git commit -m "Auto-sync $(date '+%Y-%m-%d %H:%M:%S')"
    git push
    echo "[INFO] $(date) - Sync complete"
    sleep 300
done