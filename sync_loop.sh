#!/bin/bash

while true; do
    sync >> ~/sync.log 2>&1
    sleep 300
done