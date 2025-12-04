# PhotoSync - Store Submission Guide

## Your Account Information
- **Email**: viktor.vishyn.369@gmail.com
- **Solana Publisher**: ✅ Already set up at publish.solanamobile.com
- **Publisher Name**: VIKTOR PAVLYSHYN (@vishyn369)

---

## Step-by-Step Submission Process

### Phase 1: Generate Release Keystore (REQUIRED FIRST)

This keystore will be used to sign your app for BOTH stores. **BACKUP THIS FILE - YOU CANNOT UPDATE YOUR APP WITHOUT IT!**

```bash
cd /Users/vishyn369/Downloads/StealthLynk/NEW/DEMO_APPS/FileSharing/PhotoBackupSystem

# Generate keystore
keytool -genkey -v -keystore photosync-release.keystore \
  -alias photosync \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000

# When prompted, enter:
# - Password: [CREATE A STRONG PASSWORD - SAVE IT!]
# - First and Last Name: VIKTOR PAVLYSHYN
# - Organizational Unit: PhotoSync
# - Organization: PhotoSync
# - City: [Your city]
# - State: [Your state]
# - Country Code: [Your country, e.g., UA]
```

**⚠️ CRITICAL: Backup this keystore file and password immediately!**

---

### Phase 2: Configure Signing for Android

#### For mobile-v2 (Main App):

1. Create `mobile-v2/android/gradle.properties` (if not exists):
```properties
PHOTOSYNC_RELEASE_STORE_FILE=../../../photosync-release.keystore
PHOTOSYNC_RELEASE_KEY_ALIAS=photosync
PHOTOSYNC_RELEASE_STORE_PASSWORD=YOUR_PASSWORD_HERE
PHOTOSYNC_RELEASE_KEY_PASSWORD=YOUR_PASSWORD_HERE
```

2. Update `mobile-v2/android/app/build.gradle`:
```gradle
android {
    ...
    signingConfigs {
        release {
            if (project.hasProperty('PHOTOSYNC_RELEASE_STORE_FILE')) {
                storeFile file(PHOTOSYNC_RELEASE_STORE_FILE)
                storePassword PHOTOSYNC_RELEASE_STORE_PASSWORD
                keyAlias PHOTOSYNC_RELEASE_KEY_ALIAS
                keyPassword PHOTOSYNC_RELEASE_KEY_PASSWORD
            }
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}
```

---

### Phase 3: Create Privacy Policy

Create a file `PRIVACY_POLICY.md` and host it on GitHub:

```markdown
# PhotoSync Privacy Policy

Last Updated: December 4, 2024

## Overview
PhotoSync is a self-hosted photo backup application. We do not collect, store, or share any personal data on external servers.

## Data Collection
- **Photos/Videos**: Stored on YOUR server only
- **Email**: Used for authentication, stored on YOUR server
- **Device UUID**: Used for device binding, stored on YOUR server
- **No Analytics**: We do not track usage or collect analytics

## Data Storage
All data is stored on the server YOU control. We have no access to your data.

## Third-Party Services
PhotoSync does not use any third-party services or analytics.

## Your Rights
You have complete control over your data. Delete your server to delete all data.

## Contact
Email: viktor.vishyn.369@gmail.com
GitHub: https://github.com/viktorvishyn369/PhotoSync
```

---

### Phase 4: Take Screenshots

You need 4-8 screenshots. Take these on your device:

1. **Login Screen** - Show the PhotoSync login
2. **Main Dashboard** - Show the beautiful backup/sync cards
3. **Backup in Progress** - Show status during backup
4. **Settings Screen** - Show server configuration
5. **Restore Complete** - Show successful restore message
6. **Info Section** - Show the uploads location info

**Screenshot Requirements:**
- Resolution: 1080x1920 (portrait) or 1440x2560
- Format: PNG or JPG
- No device frames needed
- Show actual app content

**How to take screenshots:**
```bash
# Connect your device
adb shell screencap -p /sdcard/screenshot1.png
adb pull /sdcard/screenshot1.png ~/Desktop/photosync-screenshots/

# Or just use your device's screenshot button (Power + Volume Down)
```

---

### Phase 5: Build Signed APK

#### For Solana dApp Store:

1. Update package name in `solana-dapp/app.json`:
```json
{
  "expo": {
    "android": {
      "package": "com.photosync.solana.dapp"
    }
  }
}
```

2. Build signed APK:
```bash
cd solana-dapp/android
./gradlew assembleRelease

# APK will be at:
# android/app/build/outputs/apk/release/app-release.apk
```

3. Verify signing:
```bash
jarsigner -verify -verbose -certs app-release.apk
```

#### For Google Play (AAB format):

```bash
cd mobile-v2/android
./gradlew bundleRelease

# AAB will be at:
# android/app/build/outputs/bundle/release/app-release.aab
```

---

### Phase 6: Submit to Solana dApp Store

You already have an account! Now:

1. **Go to**: https://publish.solanamobile.com
2. **Click**: "Add a dApp" → "New dApp"
3. **Fill in**:
   - **Name**: PhotoSync
   - **Package**: com.photosync.solana.dapp
   - **Category**: Utilities
   - **Short Description**: "Decentralized photo backup. Your photos, your server, your control."
   - **Full Description**: (See below)
   - **Website**: https://github.com/viktorvishyn369/PhotoSync
   - **Support Email**: viktor.vishyn.369@gmail.com

4. **Upload Assets**:
   - Icon: `solana-dapp/assets/icon.png` (512x512)
   - Screenshots: Your 4-8 screenshots
   - Feature Graphic: (Optional)

5. **Submit Release**:
   - Click "New Version"
   - Upload: `app-release.apk`
   - Version: 1.0.0
   - Release Notes: "Initial release. Decentralized photo backup with self-hosted server support."

6. **Sign Transactions**:
   - Ensure wallet has 0.2 SOL
   - Sign all transactions (ArDrive storage, NFT minting)

7. **Wait for Review**: 1-3 business days

---

### Phase 7: Submit to Google Play Store

1. **Create Account**:
   - Go to: https://play.google.com/console
   - Pay $25 one-time fee
   - Use: viktor.vishyn.369@gmail.com

2. **Create App**:
   - Click "Create app"
   - App name: PhotoSync
   - Default language: English
   - App/Game: App
   - Free/Paid: Free

3. **Complete Setup**:
   - Privacy Policy: Link to your GitHub privacy policy
   - App Category: Productivity
   - Contact Email: viktor.vishyn.369@gmail.com

4. **Upload AAB**:
   - Go to "Release" → "Production"
   - Upload: `app-release.aab`
   - Version: 1 (1.0.0)

5. **Store Listing**:
   - Short Description: "Secure, self-hosted photo backup"
   - Full Description: (See below)
   - Screenshots: Upload your 4-8 screenshots
   - Feature Graphic: 1024x500 PNG
   - App Icon: 512x512 PNG

6. **Content Rating**:
   - Complete IARC questionnaire
   - Select "No" for all sensitive content

7. **Submit for Review**

---

## App Descriptions

### Short Description (80 chars max)
```
Secure, self-hosted photo backup. Your photos, your server, your control.
```

### Full Description (4000 chars max)
```
PhotoSync - Take Control of Your Photos

PhotoSync is a revolutionary self-hosted photo backup solution that puts YOU in control. Unlike cloud services that store your data on their servers, PhotoSync lets you choose where your photos live.

🔐 KEY FEATURES:
• Self-Hosted: Run on your own server (Windows, Mac, Linux)
• Complete Privacy: Your data never leaves your control
• Device-Bound Security: UUID-based authentication
• Automatic Backup: One-tap photo and video backup
• Easy Restore: Download your media anytime
• Duplicate Prevention: Smart hash-based deduplication
• Cross-Platform: Works on any Android device
• No Subscriptions: Free and open source

📱 PERFECT FOR:
• Privacy-conscious individuals
• Anyone wanting true data ownership
• Users seeking censorship-resistant storage
• People who want to avoid monthly subscriptions

🌐 HOW IT WORKS:
1. Set up the PhotoSync server on your computer
2. Register with email and password
3. Configure local or remote server connection
4. Backup photos/videos with one tap
5. Access your media from any device
6. Restore files to PhotoSync album

💎 TECHNICAL HIGHLIGHTS:
• Headless server (no UI to expose data)
• HTTPS support for encrypted transport
• Additive sync (only uploads/downloads missing files)
• SQLite database for metadata
• Node.js backend (lightweight and fast)

🎯 USE CASES:
• Personal photo backup
• Family photo sharing (on your network)
• Professional photography backup
• Travel photo protection
• Alternative to Google Photos/iCloud

📂 SERVER REQUIREMENTS:
• Node.js 16 or higher
• 100MB+ free disk space
• Windows, Mac, or Linux
• Optional: Domain name for remote access

🔓 OPEN SOURCE:
PhotoSync is completely open source. View the code, contribute, or customize it for your needs.

GitHub: https://github.com/viktorvishyn369/PhotoSync

No data mining. No tracking. No subscriptions.
Just pure, decentralized storage under YOUR control.

---

Support: viktor.vishyn.369@gmail.com
```

---

## Cost Summary

### Solana dApp Store:
- Publisher Account: FREE (already have)
- Per Release: ~0.1-0.2 SOL (~$20-40)
- Updates: ~0.1 SOL each

### Google Play Store:
- Developer Account: $25 (one-time)
- Publishing: FREE
- Updates: FREE

---

## Timeline

### Week 1:
- ✅ Generate keystore
- ✅ Configure signing
- ✅ Create privacy policy
- ✅ Take screenshots

### Week 2:
- ✅ Build signed APK/AAB
- ✅ Submit to Solana dApp Store
- ✅ Submit to Google Play Store

### Week 3-4:
- ⏳ Wait for reviews
- ⏳ Respond to feedback
- ⏳ Apps go live!

---

## Important Reminders

1. **Backup Keystore**: Store `photosync-release.keystore` in multiple safe locations
2. **Save Password**: Write down keystore password securely
3. **Solana Wallet**: Keep your publisher wallet secure
4. **Minimum SOL**: Maintain 0.2 SOL for updates
5. **Version Numbers**: Increment for each update
6. **Response Time**: Reply to store feedback within 48 hours

---

## Next Steps

1. Generate the keystore (Phase 1)
2. Take screenshots (Phase 4)
3. Create privacy policy (Phase 3)
4. Build signed APK (Phase 5)
5. Submit to Solana dApp Store (Phase 6)
6. Submit to Google Play (Phase 7)

**Ready to start? Begin with Phase 1!** 🚀
