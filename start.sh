#!/bin/bash

git pull

set -e  # Stop script on any error

echo "🌟 Setting up your Minecraft server environment..."
echo "---------------------------------------------------"

# Step 1: Ensure 'screen' is installed
if ! command -v screen &> /dev/null; then
    echo "📦 Installing required tools (screen)..."
    sudo apt update 
    sudo apt-get install screen -y
    if command -v screen &> /dev/null; then
        echo "✅ 'screen' installed successfully."
    else
        echo "❌ Failed to install 'screen'. Please install manually."
        exit 1
    fi
else
    echo "✅ 'screen' is already installed."
fi

# Step 2: Set Java 21 or first available Java
echo "🔍 Checking for Java 21..."

java_path=$(update-alternatives --list java | grep "java-21" || update-alternatives --list java | sed -n '1p')
javac_path=$(update-alternatives --list javac | grep "java-21" || update-alternatives --list javac | sed -n '1p')

if [[ -n "$java_path" && -n "$javac_path" ]]; then
    echo "✅ Java 21 found. Setting it as default..."
    sudo update-alternatives --set java "$java_path"
    sudo update-alternatives --set javac "$javac_path"
    echo "🧪 Java version successfully set!"
else
    echo "⚠️ Java 21 not found. Using the first available version."
fi

# Step 3: Restore Tailscale state
echo "🔁 Restoring Tailscale data..."
sudo rm -rf /var/lib/tailscale
sudo cp -r ~/tailscale /var/lib/
echo "✅ Tailscale state restored."

# Step 4: Start Tailscale daemon
echo "🚀 Starting Tailscale..."
nohup sudo ~/tailscale-bin/tailscaled > ~/tailscaled.log 2>&1 &
echo "✅ Tailscale is running in the background."

# Step 5: Start Playit tunnel
echo "🌐 Connecting tunnel (Playit)..."
nohup ~/playit > ~/playit.log 2>&1 &
echo "✅ Tunnel is active."

# Step 6: Start MCSManager Daemon
echo "🛠️  Starting MCSManager Daemon..."
cd ~/FriendlySMP/panel/daemon
screen -dmS daemon bash -c "node app.js"
echo "✅ Daemon started."

# Step 7: Start MCSManager Web 
echo "🌍 Launching Web Control Panel..."
cd ~/FriendlySMP/panel/web
screen -dmS web bash -c "node app.js"
echo "✅ Web panel started."

echo "---------------------------------------------------"
echo "🎉 All systems are up and running! Happy playing!"
