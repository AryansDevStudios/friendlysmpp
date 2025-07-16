#!/bin/bash

set -e  # Exit immediately on any error

git pull

log() {
    echo -e "\e[1;32m[$(date +"%T")] $1\e[0m"
}

error() {
    echo -e "\e[1;31m[$(date +"%T")] ❌ $1\e[0m"
}

log "🌟 Setting up your Minecraft server environment..."
echo "---------------------------------------------------"

# Step 1: Ensure 'screen' and 'ethtool' are installed
if ! command -v screen &>/dev/null; then
    log "📦 Installing required tools (screen, ethtool)..."
    sudo apt update
    sudo apt-get install -y screen ethtool

    if command -v screen &>/dev/null; then
        log "✅ 'screen' installed successfully."
    else
        error "'screen' installation failed. Please install it manually."
        exit 1
    fi
else
    log "✅ 'screen' is already installed."
fi

# Step 2: Set Java 21 if available, else fallback to first available version
log "🔍 Checking for Java 21..."

java_path=$(update-alternatives --list java | grep "java-21" || update-alternatives --list java | head -n 1)
javac_path=$(update-alternatives --list javac | grep "java-21" || update-alternatives --list javac | head -n 1)

if [[ -n "$java_path" && -n "$javac_path" ]]; then
    log "✅ Java found at: $java_path"
    sudo update-alternatives --set java "$java_path"
    sudo update-alternatives --set javac "$javac_path"
    log "🧪 Java version set successfully!"
else
    error "No Java installation found. Please install Java."
    exit 1
fi

# Step 3: Restore Tailscale state
log "🔁 Restoring Tailscale state..."
sudo rm -rf /var/lib/tailscale
sudo cp -r ~/tailscale /var/lib/
log "✅ Tailscale state restored."

# Step 4: Start Tailscale daemon and configure network
log "🚀 Starting Tailscale..."
sudo sysctl -w net.ipv6.conf.all.forwarding=1
sudo ethtool -K eth0 gro on
sudo ethtool -K eth0 rx-gro-list on
sudo ethtool -K eth0 rx-udp-gro-forwarding on

nohup sudo ~/tailscale-bin/tailscaled > ~/tailscaled.log 2>&1 &
sleep 2  # Ensure tailscaled starts before bringing up
sudo ~/tailscale-bin/tailscale up --advertise-exit-node
log "✅ Tailscale is running in the background."

# Step 5: Start Playit tunnel
log "🌐 Connecting Playit tunnel..."
nohup ~/playit > ~/playit.log 2>&1 &
log "✅ Tunnel is active."

# Step 6: Start MCSManager Daemon
log "🛠️  Starting MCSManager Daemon..."
cd ~/FriendlySMP/panel/daemon
screen -dmS daemon bash -c "node app.js"
log "✅ Daemon started."

# Step 7: Start MCSManager Web
log "🌍 Launching MCSManager Web Panel..."
cd ~/FriendlySMP/panel/web
screen -dmS web bash -c "node app.js"
log "✅ Web panel started."

echo "---------------------------------------------------"
log "🎉 All systems are up and running! Happy playing!"
