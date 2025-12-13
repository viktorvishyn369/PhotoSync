#!/bin/bash
# PhotoSync Server - StealthLynk (stealthlynk.io) Installer
# Usage (recommended): curl -fsSL https://raw.githubusercontent.com/viktorvishyn369/PhotoSync/main/install-server-PhotoSync.sh | bash

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() { echo -e "${BLUE}$*${NC}"; }
warn() { echo -e "${YELLOW}$*${NC}"; }
err() { echo -e "${RED}$*${NC}"; }

log "╔════════════════════════════════════════════════════╗"
log "║   PhotoSync Server Installer (stealthlynk.io)     ║"
log "╚════════════════════════════════════════════════════╝"

# Root/sudo detection
if [ "${EUID:-$(id -u)}" -eq 0 ]; then
  SUDO=""
else
  SUDO="sudo"
fi

# Determine which user should run the systemd service.
# When executed with sudo, $USER may be "root".
SERVICE_USER="${SUDO_USER:-${USER:-$(whoami)}}"

INSTALL_DIR="/opt/photosync"
SERVICE_NAME="photosync"
SERVICE_FILE="/etc/systemd/system/${SERVICE_NAME}.service"

# For stealthlynk.io we want predictable paths under /opt/photosync/server
UPLOAD_DIR="${INSTALL_DIR}/server/uploads"
DB_PATH="${INSTALL_DIR}/server/backup.db"
CLOUD_DIR="${INSTALL_DIR}/server/cloud"

ensure_cmd() {
  local cmd="$1"
  local install_hint="$2"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    err "✗ Missing required command: ${cmd}"
    warn "$install_hint"
    exit 1
  fi
}

install_git_if_missing() {
  log "[1/6] Checking Git..."
  if command -v git >/dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} Git found: $(git --version)"
    return
  fi

  warn "⚠ Git not found. Installing..."
  if command -v apt-get >/dev/null 2>&1; then
    $SUDO apt-get update -y
    $SUDO apt-get install -y git
  elif command -v dnf >/dev/null 2>&1; then
    $SUDO dnf install -y git
  elif command -v yum >/dev/null 2>&1; then
    $SUDO yum install -y git
  elif command -v pacman >/dev/null 2>&1; then
    $SUDO pacman -S --noconfirm git
  else
    err "✗ Could not install Git automatically"
    warn "Install Git manually and rerun this script."
    exit 1
  fi

  echo -e "${GREEN}✓${NC} Git installed"
}

install_node_if_missing() {
  log "[2/6] Checking Node.js..."
  if command -v node >/dev/null 2>&1 && command -v npm >/dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} Node.js found: $(node -v)"
    return
  fi

  warn "⚠ Node.js not found. Installing LTS..."
  if command -v apt-get >/dev/null 2>&1; then
    curl -fsSL https://deb.nodesource.com/setup_lts.x | $SUDO -E bash -
    $SUDO apt-get install -y nodejs
  elif command -v dnf >/dev/null 2>&1; then
    curl -fsSL https://rpm.nodesource.com/setup_lts.x | $SUDO bash -
    $SUDO dnf install -y nodejs
  elif command -v yum >/dev/null 2>&1; then
    curl -fsSL https://rpm.nodesource.com/setup_lts.x | $SUDO bash -
    $SUDO yum install -y nodejs
  elif command -v pacman >/dev/null 2>&1; then
    $SUDO pacman -S --noconfirm nodejs npm
  else
    err "✗ Could not install Node.js automatically"
    warn "Install Node.js manually from https://nodejs.org/ and rerun this script."
    exit 1
  fi

  echo -e "${GREEN}✓${NC} Node.js installed: $(node -v)"
}

clone_or_update_repo() {
  log "[3/6] Downloading / updating PhotoSync..."

  if [ -d "$INSTALL_DIR/.git" ]; then
    warn "⚠ Existing repo found at $INSTALL_DIR. Updating..."
    cd "$INSTALL_DIR"
    $SUDO git pull
  else
    if [ -d "$INSTALL_DIR" ]; then
      warn "⚠ Directory exists at $INSTALL_DIR but is not a git repo."
      warn "   Please move it aside or delete it, then rerun."
      exit 1
    fi
    $SUDO git clone https://github.com/viktorvishyn369/PhotoSync.git "$INSTALL_DIR"
    cd "$INSTALL_DIR"
  fi

  echo -e "${GREEN}✓${NC} Repo ready at $INSTALL_DIR"
}

install_server_deps() {
  log "[4/6] Installing server dependencies..."
  cd "$INSTALL_DIR/server"
  $SUDO npm install --production
  echo -e "${GREEN}✓${NC} Server dependencies installed"
}

write_systemd_unit() {
  log "[5/6] Configuring systemd service (${SERVICE_NAME})..."

  # Ensure storage dirs exist (important for StealthCloud)
  $SUDO mkdir -p "$UPLOAD_DIR" "$CLOUD_DIR"

  # Default to service user ownership if possible
  $SUDO chown -R "$SERVICE_USER":"$SERVICE_USER" "$UPLOAD_DIR" "$CLOUD_DIR" 2>/dev/null || true

  $SUDO tee "$SERVICE_FILE" > /dev/null <<EOF
[Unit]
Description=PhotoSync Server (stealthlynk.io)
After=network.target

[Service]
Type=simple
User=$SERVICE_USER
WorkingDirectory=$INSTALL_DIR/server
Environment="UPLOAD_DIR=$UPLOAD_DIR"
Environment="DB_PATH=$DB_PATH"
Environment="CLOUD_DIR=$CLOUD_DIR"
ExecStart=$(which node) server.js
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal
SyslogIdentifier=photosync

[Install]
WantedBy=multi-user.target
EOF

  $SUDO systemctl daemon-reload
  $SUDO systemctl enable "$SERVICE_NAME"
  $SUDO systemctl restart "$SERVICE_NAME"

  echo -e "${GREEN}✓${NC} systemd service installed: $SERVICE_FILE"
}

open_firewall_if_present() {
  log "[6/6] Firewall configuration (port 3000)..."
  if command -v ufw >/dev/null 2>&1; then
    $SUDO ufw allow 3000/tcp
    echo -e "${GREEN}✓${NC} UFW: Port 3000 opened"
  elif command -v firewall-cmd >/dev/null 2>&1; then
    $SUDO firewall-cmd --permanent --add-port=3000/tcp
    $SUDO firewall-cmd --reload
    echo -e "${GREEN}✓${NC} Firewalld: Port 3000 opened"
  else
    warn "⚠ No firewall tool detected (ufw/firewalld). Skipping."
  fi
}

# --- Run ---
install_git_if_missing
install_node_if_missing
ensure_cmd curl "Install curl and rerun."

clone_or_update_repo
install_server_deps
write_systemd_unit
open_firewall_if_present

echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✓ PhotoSync Server installed and running${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BLUE}Service:${NC}"
echo -e "  Status:  ${YELLOW}sudo systemctl status photosync${NC}"
echo -e "  Logs:    ${YELLOW}sudo journalctl -u photosync -f${NC}"
echo ""
echo -e "${BLUE}Storage paths (stealthlynk.io):${NC}"
echo -e "  UPLOAD_DIR: ${YELLOW}$UPLOAD_DIR${NC}"
echo -e "  CLOUD_DIR:  ${YELLOW}$CLOUD_DIR${NC}"
echo ""
echo -e "${BLUE}Note:${NC} Nginx/Cloudflare tunnel should proxy https://stealthlynk.io/api/* to this service on :3000."
