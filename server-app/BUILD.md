# PhotoSync Server GUI - Build Guide

This guide explains how to build distributable desktop applications for macOS, Windows, and Linux.

## 📦 What Gets Built

### macOS
- **DMG** - Disk image installer (drag-and-drop)
- **ZIP** - Portable archive
- **Architectures**:
  - Intel (x64) - For Intel Macs
  - Apple Silicon (arm64) - For M1/M2/M3 Macs
  - Universal - Works on both Intel and Apple Silicon

### Windows
- **NSIS Installer** - Standard Windows installer (.exe)
- **Portable** - No installation required (.exe)
- **Architectures**:
  - 64-bit (x64) - Modern Windows
  - 32-bit (ia32) - Older Windows systems

### Linux
- **AppImage** - Universal Linux binary (works on all distros)
- **DEB** - Debian/Ubuntu package
- **RPM** - Fedora/RHEL/CentOS package
- **Architectures**:
  - x64 - Standard Linux
  - arm64 - ARM Linux (Raspberry Pi, etc.)

## 🚀 Building

### Prerequisites
```bash
cd server-app
npm install
```

### Build for Your Current Platform
```bash
npm run build
```

### Build for Specific Platforms

**macOS (all variants):**
```bash
npm run build-mac              # All Mac architectures
npm run build-mac-intel        # Intel only
npm run build-mac-arm          # Apple Silicon only
npm run build-mac-universal    # Universal binary
```

**Windows:**
```bash
npm run build-win              # Both installer and portable
```

**Linux:**
```bash
npm run build-linux            # AppImage, DEB, and RPM
```

**All Platforms (from macOS only):**
```bash
npm run build-all              # Mac, Windows, and Linux
```

## 📁 Output Location

Built applications will be in:
```
server-app/dist/
```

### File Naming Examples:
- `PhotoSync Server-1.0.0.dmg` (macOS Intel)
- `PhotoSync Server-1.0.0-arm64.dmg` (macOS Apple Silicon)
- `PhotoSync Server-1.0.0-universal.dmg` (macOS Universal)
- `PhotoSync Server Setup 1.0.0.exe` (Windows Installer)
- `PhotoSync Server 1.0.0.exe` (Windows Portable)
- `PhotoSync-Server-1.0.0.AppImage` (Linux Universal)
- `photosync-server_1.0.0_amd64.deb` (Linux Debian/Ubuntu)
- `photosync-server-1.0.0.x86_64.rpm` (Linux Fedora/RHEL)

## 🔧 Build Requirements

### macOS Builds
- **Can build on**: macOS only
- **Requires**: Xcode Command Line Tools
- **Can target**: macOS, Windows, Linux

### Windows Builds
- **Can build on**: Windows, macOS (with Wine), Linux (with Wine)
- **Requires**: Nothing special on Windows
- **Can target**: Windows only (from Windows)

### Linux Builds
- **Can build on**: Linux, macOS, Windows (WSL)
- **Requires**: Standard build tools
- **Can target**: Linux only

## 📝 Build Configuration

All build settings are in `package.json`:
- Icon: `icon.png` (857KB PNG)
- App ID: `com.photosync.server`
- Product Name: `PhotoSync Server`
- Version: `1.0.0`

## 🎯 Distribution Checklist

Before distributing:
- [ ] Update version in `package.json`
- [ ] Test on target platform
- [ ] Verify icon appears correctly
- [ ] Check app launches and server starts
- [ ] Test uploads folder creation
- [ ] Verify database initialization

## 📦 What's Included in Build

**Included:**
- ✅ Electron runtime
- ✅ Node.js runtime
- ✅ All dependencies
- ✅ Server code
- ✅ GUI interface
- ✅ App icon

**Not Included (created at runtime):**
- ❌ backup.db (created on first run)
- ❌ uploads/ folder (created on first run)
- ❌ User data

## 🔒 Code Signing (Optional)

### macOS
```bash
# Sign with Apple Developer certificate
export CSC_LINK=/path/to/certificate.p12
export CSC_KEY_PASSWORD=your_password
npm run build-mac
```

### Windows
```bash
# Sign with code signing certificate
export CSC_LINK=/path/to/certificate.pfx
export CSC_KEY_PASSWORD=your_password
npm run build-win
```

## 🌍 Platform-Specific Notes

### macOS
- Universal builds work on both Intel and Apple Silicon
- Users may need to allow app in Security & Privacy settings
- First launch may show "unidentified developer" warning

### Windows
- NSIS installer requires admin rights
- Portable version doesn't require installation
- Windows Defender may scan on first run

### Linux
- AppImage works on all distributions (no installation)
- DEB for Debian/Ubuntu/Mint
- RPM for Fedora/RHEL/CentOS/openSUSE
- May need to make AppImage executable: `chmod +x PhotoSync-Server-*.AppImage`

## 📊 Build Sizes (Approximate)

- **macOS DMG**: ~150-200 MB (per architecture)
- **macOS Universal**: ~300 MB (both architectures)
- **Windows Installer**: ~150 MB
- **Windows Portable**: ~150 MB
- **Linux AppImage**: ~150 MB
- **Linux DEB/RPM**: ~150 MB

## 🚀 Quick Start for Users

### macOS
1. Download DMG
2. Open DMG
3. Drag PhotoSync Server to Applications
4. Launch from Applications

### Windows
1. Download installer
2. Run installer
3. Follow installation wizard
4. Launch from Start Menu or Desktop

### Linux
1. Download AppImage
2. Make executable: `chmod +x PhotoSync-Server-*.AppImage`
3. Double-click to run
4. Or install DEB/RPM with package manager

## 🆘 Troubleshooting

### Build Fails
```bash
# Clean and rebuild
rm -rf dist node_modules
npm install
npm run build
```

### Icon Not Showing
- Ensure `icon.png` exists in server-app directory
- PNG must be at least 512x512px
- Rebuild after adding icon

### App Won't Launch
- Check console for errors
- Verify Node.js dependencies installed
- Ensure server.js is included in build

## 📚 Resources

- [Electron Builder Docs](https://www.electron.build/)
- [Code Signing Guide](https://www.electron.build/code-signing)
- [Multi-Platform Build](https://www.electron.build/multi-platform-build)
