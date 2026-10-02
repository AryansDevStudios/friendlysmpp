# ⛏️ friendlysmpp

> Automated Paper Minecraft server orchestration suite with Tailscale VPN exit node routing, Playit.gg tunneling, and continuous Git world backup loops.

![Bash](https://img.shields.io/badge/Language-Bash%20%2F%20Shell-4EAA25?logo=gnu-bash&logoColor=white)
![Java](https://img.shields.io/badge/Java-21%20LTS-ED8B00?logo=openjdk&logoColor=white)
![Minecraft](https://img.shields.io/badge/Minecraft-Paper%20Server-388E3C?logo=minecraft&logoColor=white)
![Tailscale](https://img.shields.io/badge/VPN-Tailscale-24292E?logo=tailscale&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Linux%20%2F%20Screen-FCC624?logo=linux&logoColor=black)
![Status](https://img.shields.io/badge/Status-Active-brightgreen)
![License](https://img.shields.io/badge/License-MIT-blue)

---

## 📖 Overview

**friendlysmpp** is an automated DevOps and orchestration toolkit for hosting and maintaining the FriendlySMP cross-platform Minecraft server. Built for headless Linux environments, it streamlines server bootstrapping, dependency configuration, network tunneling, and world backup synchronization into clean, reliable shell scripts.

The suite configures high-performance Tailscale mesh networking with exit node advertising and UDP offloading, runs public network tunneling via Playit.gg, manages MCSManager daemons inside detached GNU Screen sessions, and runs continuous 5-minute Git synchronization loops to safeguard world data.

---

## ✨ Features

- **One-Command Master Bootstrap (`start.sh`)**: Automatically pulls upstream master updates, installs `screen`, detects and selects Java 21 via `update-alternatives`, runs Tailscale routing, and launches management daemons.
- **Tailscale Mesh & Exit Node (`start_ts.sh`)**: Enables Linux kernel IP forwarding (`net.ipv4.ip_forward=1`), initializes `tailscaled`, advertises the host as an exit node (`--advertise-exit-node --accept-routes`), and boosts UDP performance via `ethtool` GRO offloading.
- **Zero-Port-Forward Public Tunneling**: Seamlessly runs Playit.gg in the background to provide players with low-latency public connection endpoints without requiring router port-forwarding.
- **Detached Screen Session Management**: Spawns MCSManager daemon and web control panel inside separate background screen sessions (`daemon`, `web`), keeping services persistent across SSH disconnects.
- **Automated 5-Minute Git World Backups (`sync_loop.sh`)**: Daemonized sync loop staging, committing, and pushing world maps, player data, and configurations to GitHub every 300 seconds with an interactive terminal countdown.
- **Cross-Version & Bedrock Support**: Configured with ViaVersion and ViaRewind for backwards/forwards version compatibility, and Floodgate for authentication-free Bedrock player connections.
- **Live 3D Web World Map**: Bundles BlueMap for real-time 3D browser exploration of Overworld, Nether, and The End dimensions.
- **In-Game Token Economy**: Integrated `xTokenSMP` plugin for player economy, shops, and server reward mechanisms.

---

## 🛠️ Tech Stack

- **Operating Environment**: Linux (Ubuntu / Debian / Cloud VPS)
- **Runtime & Core**: [Java 21 OpenJDK](https://openjdk.org/), [PaperMC](https://papermc.io/)
- **Networking**: [Tailscale](https://tailscale.com/), [Playit.gg](https://playit.gg/)
- **Management & Monitoring**: [MCSManager](https://mcsmanager.com/) (Node.js Web Panel & Daemon), GNU Screen
- **Automation**: Bash Scripts, Git

---

## 📁 Project Structure

```
friendlysmpp/
├── .bashrc                   # Shell environment initialization
├── .gitconfig                # Dedicated Git configuration
├── backup_tailscale.sh       # Tailscale credential and state backup script
├── start.sh                  # Master server orchestration script
├── start_ts.sh               # Tailscale exit node & network accelerator
├── sync.sh                   # Manual one-time Git commit and push script
├── sync_loop.sh              # Continuous 5-minute automated backup daemon
├── tailscale_binary/         # Persistent Tailscale, tailscaled & ethtool binaries
└── FriendlySMP/              # Main Minecraft server directory
    ├── server.properties     # Vanilla/Paper server configuration
    ├── spigot.yml            # Spigot engine performance settings
    ├── world/                # Overworld level, chunk and player data
    ├── world_nether/         # Nether dimension world data
    ├── world_the_end/        # The End dimension world data
    ├── panel/                # MCSManager web interface and daemon source
    └── plugins/              # Server plugins (ViaVersion, BlueMap, Floodgate, xTokenSMP)
```

---

## 🚀 Getting Started

### Prerequisites

- Linux server / VM (Ubuntu 20.04+ or Debian 11+ recommended)
- Java 21 OpenJDK installed (`sudo apt install openjdk-21-jdk`)
- Node.js (for MCSManager panel)
- Git configured with commit and push permissions

### 1. Clone Repository

```bash
git clone https://github.com/AryansDevStudios/friendlysmpp.git ~/friendlysmpp
cd ~/friendlysmpp
```

### 2. Make Scripts Executable

```bash
chmod +x start.sh start_ts.sh sync.sh sync_loop.sh backup_tailscale.sh
```

### 3. Launch Master Orchestration

```bash
./start.sh
```

The script will:
1. Verify and install `screen`
2. Configure active Java version to Java 21
3. Start Tailscale VPN and advertise exit nodes
4. Launch the Playit.gg tunnel in the background
5. Spin up MCSManager Web Panel and Daemon in screen sessions

### 4. Start World Backup Loop (Optional)

In a separate terminal or screen session:

```bash
./sync_loop.sh
```

---

## 🕹️ Screen Management

To interact with the running MCSManager daemon or web panel:

```bash
# List active screen sessions
screen -ls

# Attach to MCSManager Daemon
screen -r daemon

# Attach to MCSManager Web Panel
screen -r web

# Detach from any screen session
Press: Ctrl + A, then D
```

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to open an issue or submit a pull request.

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
