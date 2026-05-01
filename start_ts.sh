#!/bin/bash
# File path: /home/aryan0106gupta/start_ts.sh

# ==========================================
# 0. Safety Check: Is Tailscale already running?
# ==========================================
# pgrep checks for the process. If found, it skips the rest of the script.
if pgrep -x "tailscaled" > /dev/null; then
    echo "Tailscale is already running."
    exit 0
fi

# ==========================================
# Original Script Begins Here
# ==========================================
# Define persistent paths
MY_BIN="$HOME/tailscale_binary/ethtool"
MY_LIB="$HOME/tailscale_binary/lib"

echo "Applying Available Network Optimizations..."

# 1. Enable Forwarding (Necessary for Exit Nodes)
echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
sudo sysctl -p /etc/sysctl.d/99-tailscale.conf
echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.conf
echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p /etc/sysctl.conf


# 2. Cleanup: Kill any old stuck processes before starting
sudo pkill -9 tailscaled 2>/dev/null

# 3. Setup Tailscale Environment
sudo mkdir -p /var/lib/tailscale
# Make sure binaries are executable
chmod +x $HOME/tailscale_binary/tailscaled $HOME/tailscale_binary/tailscale 2>/dev/null

if [ -d "$HOME/tailscale_binary/config" ]; then
    sudo cp -r $HOME/tailscale_binary/config/. /var/lib/tailscale/
fi

# 4. Start Daemon
echo "Starting Tailscale..."
sudo $HOME/tailscale_binary/tailscaled > /dev/null 2>&1 &

sleep 5

# 5. Bring up Tailscale
echo "Connecting to Tailnet..."
sudo $HOME/tailscale_binary/tailscale up --advertise-exit-node --reset --accept-routes
sudo $HOME/tailscale_binary/tailscale web > /dev/null 2>&1 &
## Can use http://mainserver:8088

# 6. Apply ethtool offloading using the SAVED binary
NETDEV=$(ip -o route get 8.8.8.8 | cut -f 5 -d " ")
if [ -f "$MY_BIN" ]; then
    echo "Optimizing interface $NETDEV..."
    sudo LD_LIBRARY_PATH=$MY_LIB $MY_BIN -K $NETDEV rx-udp-gro-forwarding on rx-gro-list off 2>/dev/null
fi

# 7. Final safety MTU Reset
sudo ip link set dev $NETDEV mtu 1500

echo "--- Setup Complete ---"
sudo $HOME/tailscale_binary/tailscale status --peers