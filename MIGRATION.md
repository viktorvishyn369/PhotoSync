# Migration Guide: User ID → Device UUID Folders

## Overview

PhotoSync has been updated to use device UUID-based folders instead of user ID-based folders for better scalability and cloud service compatibility.

## Old Structure (Before)
```
uploads/
  ├── 1/          ← User ID (auto-increment)
  ├── 2/
  └── 3/
```

## New Structure (After)
```
uploads/
  ├── a3bb189e-8bf9-5888-9912-ace4e6543002/  ← Device UUID
  ├── f7c2d8e1-4a3b-5c9d-8e2f-1a4b5c6d7e8f/
  └── b1c2d3e4-5f6a-7b8c-9d0e-1f2a3b4c5d6e/
```

## Migration Steps

### For Fresh Installations
No migration needed! The new system will automatically create UUID-based folders.

### For Existing Installations

If you have existing data in user ID folders (1, 2, 3, etc.), follow these steps:

#### 1. Stop the Server
```bash
# If running as service
sudo systemctl stop photosync-server  # Linux
launchctl unload ~/Library/LaunchAgents/com.photosync.server.plist  # macOS

# Or just close the server app
```

#### 2. Run Migration Script

**For server-app (GUI):**
```bash
cd server-app
node migrate-to-uuid.js
```

**For server (CLI):**
```bash
cd server
node migrate-to-uuid.js
```

#### 3. Verify Migration
The script will:
- Read device UUIDs from the database
- Rename folders from user_id to device_uuid
- Show a summary of migrated folders

Example output:
```
🔄 Starting migration from user_id folders to device_uuid folders...

✅ Connected to database

📋 Found 2 device(s) to migrate:

[1/2] Processing:
  User ID: 1
  Device UUID: a3bb189e-8bf9-5888-9912-ace4e6543002
  Old folder: ./uploads/1
  New folder: ./uploads/a3bb189e-8bf9-5888-9912-ace4e6543002
  ✅ Migrated successfully!

[2/2] Processing:
  User ID: 2
  Device UUID: f7c2d8e1-4a3b-5c9d-8e2f-1a4b5c6d7e8f
  Old folder: ./uploads/2
  New folder: ./uploads/f7c2d8e1-4a3b-5c9d-8e2f-1a4b5c6d7e8f
  ✅ Migrated successfully!

═══════════════════════════════════════
📊 Migration Summary:
  Total devices: 2
  Successfully migrated: 2
  Errors: 0
  Skipped: 0
═══════════════════════════════════════

✅ Migration completed successfully!
```

#### 4. Restart Server
```bash
# Start the server again
sudo systemctl start photosync-server  # Linux
launchctl load ~/Library/LaunchAgents/com.photosync.server.plist  # macOS

# Or start the server app normally
```

#### 5. Test
- Login to the mobile app
- Check Settings → Device ID to see your UUID
- Upload a test photo
- Verify files appear in the UUID-named folder

## Important Notes

⚠️ **Backup First**: Always backup your `uploads/` folder before migration

✅ **Safe Operation**: The migration script only renames folders, no data is deleted

✅ **Idempotent**: Running the script multiple times is safe - it skips already migrated folders

✅ **Automatic**: New users will automatically get UUID-based folders

## Rollback (If Needed)

If you need to rollback:

1. Stop the server
2. Manually rename folders back:
   ```bash
   cd uploads
   mv a3bb189e-8bf9-5888-9912-ace4e6543002 1
   mv f7c2d8e1-4a3b-5c9d-8e2f-1a4b5c6d7e8f 2
   ```
3. Revert to previous server version

## Benefits of UUID-Based Folders

✅ **Scalable**: Works in distributed/cloud environments
✅ **No Conflicts**: UUIDs are globally unique
✅ **Trackable**: Easy to identify which device owns which data
✅ **Portable**: Folders can be moved between servers
✅ **Future-Proof**: Ready for centralized cloud service

## Support

If you encounter issues during migration:
1. Check the migration script output for errors
2. Verify database connectivity
3. Ensure proper file permissions
4. Check GitHub issues: https://github.com/viktorvishyn369/PhotoSync/issues
