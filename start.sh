#!/bin/bash

set -e  # Exit immediately on any error

git pull origin master

log() {
    echo -e "\e[1;32m[$(date +"%T")] $1\e[0m"
}

error() {
    echo -e "\e[1;31m[$(date +"%T")] ❌ $1\e[0m"
}

log "🌟 Setting up your Minecraft server environment..."
echo "---------------------------------------------------"

# Step 1: Ensure 'screen' is installed
if ! command -v screen &>/dev/null; then
    log "📦 Installing required tools (screen)..."
    sudo apt update
    sudo apt-get install -y screen
    log "✅ 'screen' installed successfully."
else
    log "✅ 'screen' is already installed."
fi

# Step 2: Java Configuration
log "🔍 Checking for Java 21..."
java_path=$(update-alternatives --list java | grep "java-21" || update-alternatives --list java | head -n 1)
javac_path=$(update-alternatives --list javac | grep "java-21" || update-alternatives --list javac | head -n 1)

if [[ -n "$java_path" && -n "$javac_path" ]]; then
    sudo update-alternatives --set java "$java_path"
    sudo update-alternatives --set javac "$javac_path"
    log "🧪 Java version set successfully!"
else
    error "No Java installation found."
    exit 1
fi

# Step 3: Run the new Tailscale Script
log "🚀 Launching updated Tailscale configuration..."
if [ -f ~/start_ts.sh ]; then
    chmod +x ~/start_ts.sh
    ~/start_ts.sh
    log "✅ Tailscale script executed."
else
    error "Tailscale script (~/start_ts.sh) not found!"
    exit 1
fi

# Step 4: Start Playit tunnel
log "🌐 Connecting Playit tunnel..."
nohup ~/playit > ~/playit.log 2>&1 &
log "✅ Tunnel is active."

# Step 5: Start MCSManager Daemon
log "🛠️  Starting MCSManager Daemon..."
cd ~/FriendlySMP/panel/daemon
screen -dmS daemon bash -c "node app.js"
log "✅ Daemon started."

# Step 6: Start MCSManager Web
log "🌍 Launching MCSManager Web Panel..."
cd ~/FriendlySMP/panel/web
screen -dmS web bash -c "node app.js"
log "✅ Web panel started."

echo "---------------------------------------------------"
log "🎉 All systems are up and running! Happy playing!"