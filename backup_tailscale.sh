#!/bin/bash
mkdir -p $HOME/tailscale_binary

echo "Copying binaries..."
cp $(which tailscale) $HOME/tailscale_binary/
cp $(which tailscaled) $HOME/tailscale_binary/

echo "Copying configuration folder..."
# We copy the contents of the folder to our backup
sudo cp -r /var/lib/tailscale/ $HOME/tailscale_binary/config

# Recursive chown so you can actually move/edit these files later
sudo chown -R $USER:$USER $HOME/tailscale_binary/

echo "Backup complete!"