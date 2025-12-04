# PhotoSync Server Installation Guide

Choose the right installation script for your system:

## 🖥️ Desktop Systems (GUI Server)

For computers with a desktop environment where you want a graphical interface:

### macOS
```bash
cd server
./install-macos.sh
```
**Installs:** GUI server app with system tray icon and visual interface

### Windows
```powershell
cd server
.\install-windows.ps1
```
**Installs:** GUI server app with system tray icon and visual interface

### Linux Desktop (Ubuntu, Fedora, etc.)
```bash
cd server
sudo ./install-linux.sh
```
**Installs:** GUI server app with system tray icon and visual interface

---

## 🖧 Server Systems (Headless CLI)

For headless servers without a desktop environment:

### Ubuntu Server / Debian Server
```bash
cd server
sudo ./install-ubuntu-server.sh
```
**Installs:** Command-line server only (no GUI, lightweight)

---

## 📦 What Gets Installed?

### GUI Version (Desktop)
- ✅ Electron app with visual interface
- ✅ System tray icon
- ✅ Easy server management through UI
- ✅ Auto-start on login
- ✅ Auto-restart on crash

### CLI Version (Server)
- ✅ Lightweight Node.js server
- ✅ Systemd service (Linux)
- ✅ Auto-start on boot
- ✅ Auto-restart on crash
- ✅ Minimal resource usage

---

## 🔧 After Installation

### Desktop (GUI)
- Look for PhotoSync icon in system tray
- Click to open server interface
- Server runs automatically on startup

### Server (CLI)
- Check status: `sudo systemctl status photosync-server`
- View logs: `sudo journalctl -u photosync-server -f`
- Server runs automatically on boot

---

## 📱 Mobile App Configuration

Both versions run on **port 3000** by default.

**Local Network:**
- Use your computer's local IP: `192.168.1.x:3000`

**Remote Access:**
- Use your public IP: `your-public-ip:3000`
- Requires port forwarding on your router

---

## 🆘 Troubleshooting

### GUI won't start
- Check if Node.js is installed: `node -v`
- Check logs in the server-app directory

### CLI service won't start
- Check status: `sudo systemctl status photosync-server`
- View logs: `sudo journalctl -u photosync-server -n 50`

### Can't connect from mobile
- Check firewall allows port 3000
- Verify server IP address
- Ensure phone and server are on same network (for local)

---

## 📂 File Locations

**Uploaded Photos:**
- Desktop: `server-app/uploads/[user_id]/`
- Server: `server/uploads/[user_id]/`

**Database:**
- Desktop: `server-app/backup.db`
- Server: `server/backup.db`

**Logs:**
- macOS: `~/Library/Logs/PhotoSync/`
- Windows: Event Viewer → Application
- Linux: `journalctl -u photosync-server`
