# PhotoSync - Installation Guide

## 🚀 One-Line Install (Easiest!)

### macOS / Linux
Open Terminal and paste:
```bash
curl -fsSL https://raw.githubusercontent.com/viktorvishyn369/PhotoSync/main/install.sh | bash
```

### Windows
Open PowerShell as Administrator and paste:
```powershell
irm https://raw.githubusercontent.com/viktorvishyn369/PhotoSync/main/install.ps1 | iex
```

**That's it!** The script will:
- ✅ Install Node.js (if needed)
- ✅ Download PhotoSync
- ✅ Install all dependencies
- ✅ Start the server with system tray

## 📱 What You Get

### Server (Desktop)
- System tray icon
- Click to control server
- Open files location
- Stop/Start/Restart
- Runs on port 3000

### Mobile App
- Download APK from [Releases](https://github.com/viktorvishyn369/PhotoSync/releases)
- Install on Android
- Connect to your server
- Backup and restore photos

## 🔧 Manual Installation

If you prefer manual installation:

### 1. Install Node.js
Download from: https://nodejs.org/

### 2. Clone Repository
```bash
git clone https://github.com/viktorvishyn369/PhotoSync.git
cd PhotoSync
```

### 3. Install Dependencies
```bash
# Server
cd server
npm install

# Tray App
cd ../server-tray
npm install
```

### 4. Run
```bash
cd server-tray
npm start
```

## 🌐 Finding Your Server IP

### macOS / Linux
```bash
ifconfig | grep "inet " | grep -v 127.0.0.1
```

### Windows
```powershell
ipconfig
```

Look for your local IP (usually starts with 192.168.x.x or 10.x.x.x)

## 📚 More Info

- [Global Installation Guide](GLOBAL_INSTALL.md) - Worldwide installation
- [Server Quick Start](server/QUICK_START.md) - Server setup
- [Privacy Policy](PRIVACY_POLICY.md) - Privacy information

## 🆘 Troubleshooting

### Script fails to install Node.js
Install Node.js manually from https://nodejs.org/ then run the script again.

### Port 3000 already in use
Stop any other service using port 3000:
```bash
# macOS/Linux
lsof -ti:3000 | xargs kill -9

# Windows
netstat -ano | findstr :3000
taskkill /PID <PID> /F
```

### Can't see tray icon
- **macOS**: Check menu bar (top-right)
- **Windows**: Check system tray (bottom-right, may be hidden)
- **Linux**: Ensure system tray is enabled in your desktop environment

## ✅ Success!

When installed correctly:
1. Tray icon appears
2. Server runs on port 3000
3. Mobile app can connect
4. Photos backup automatically

**Enjoy PhotoSync!** 🎉
