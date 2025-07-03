#!/bin/bash

while true; do
    bash ~/sync.sh >> ~/sync.log 2>&1
    sleep 300
done