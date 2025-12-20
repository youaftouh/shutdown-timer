#!/bin/bash

echo "Creating perfect DMG - no scrolling..."

# Clean up everything
rm -rf build_perfect/
rm -f ShutdownTimer.dmg

# Use timestamp for uniqueness
TIMESTAMP=$(date +%s)
VOLUME_NAME="ShutdownTimer"

# Create build directory
mkdir build_perfect

# Copy app
cp -R ShutdownTimer.app build_perfect/

# Create Applications symlink
ln -s /Applications build_perfect/Applications

# Create DMG
hdiutil create -srcfolder build_perfect -volname "${VOLUME_NAME}" -fs HFS+ -format UDRW -size 8m temp-perfect.dmg

# Mount
device=$(hdiutil attach -readwrite -noverify -noautoopen temp-perfect.dmg | egrep '^/dev/' | sed 1q | awk '{print $1}')
sleep 3

# Configure with slightly wider window to eliminate horizontal scroll
osascript << EOF
tell application "Finder"
    tell disk "${VOLUME_NAME}"
        open
        set current view of container window to icon view
        set toolbar visible of container window to false
        set statusbar visible of container window to false
        -- 380x260 window (20px wider to eliminate horizontal scroll)
        set bounds of container window to {300, 300, 680, 560}
        set theViewOptions to the icon view options of container window
        set arrangement of theViewOptions to not arranged
        set icon size of theViewOptions to 64
        -- Centered layout with no scrolling
        set position of item "ShutdownTimer.app" of container window to {100, 110}
        set position of item "Applications" of container window to {280, 110}
        update without registering applications
        delay 4
        close
    end tell
end tell
EOF

sleep 3
hdiutil detach ${device}

# Convert to final DMG with clean filename
hdiutil convert temp-perfect.dmg -format UDZO -imagekey zlib-level=9 -o ShutdownTimer.dmg

# Clean up
rm -f temp-perfect.dmg
rm -rf build_perfect/

echo "✅ Created: ShutdownTimer.dmg"
echo "📦 Clean filename, instructional window title!"
ls -lh ShutdownTimer.dmg