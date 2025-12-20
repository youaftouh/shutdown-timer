#!/bin/bash

VERSION="1.0.0"
RELEASE_NAME="ShutdownTimer-v${VERSION}"

echo "Creating release package: ${RELEASE_NAME}"

# Clean up
rm -rf release/
rm -f ${RELEASE_NAME}.zip

# Create release directory
mkdir -p release/${RELEASE_NAME}

# Copy main files
cp -R ShutdownTimer.app release/${RELEASE_NAME}/
cp README.md release/${RELEASE_NAME}/
cp LICENSE release/${RELEASE_NAME}/
cp CHANGELOG.md release/${RELEASE_NAME}/

# Copy the DMG
cp ShutdownTimer.dmg release/${RELEASE_NAME}/

# Create installation instructions
cat > release/${RELEASE_NAME}/INSTALL.txt << 'EOF'
INSTALLATION INSTRUCTIONS
========================

OPTION 1 - Easy Installation (Recommended):
1. Double-click "ShutdownTimer-v1.0.dmg"
2. Drag "ShutdownTimer.app" to the "Applications" folder
3. Launch from Applications folder

OPTION 2 - Manual Installation:
1. Copy "ShutdownTimer.app" to your Applications folder
2. Launch the app

FIRST RUN:
- macOS will ask for permission to control System Events
- This is required for shutdown/restart/logout functionality
- Grant permission in: System Settings → Privacy & Security → Automation

SYSTEM REQUIREMENTS:
- macOS 13.0 (Ventura) or later
- Intel or Apple Silicon Mac

SUPPORT:
If you have issues, check the README.md file for troubleshooting.

Enjoy your Shutdown Timer!
EOF

# Create a source code package
mkdir -p release/${RELEASE_NAME}/source
cp ShutdownTimer.swift release/${RELEASE_NAME}/source/
cp Info.plist release/${RELEASE_NAME}/source/
cp create_icon.sh release/${RELEASE_NAME}/source/
cp create_dmg.sh release/${RELEASE_NAME}/source/

cat > release/${RELEASE_NAME}/source/BUILD.txt << 'EOF'
BUILD INSTRUCTIONS
==================

To build from source:

1. Ensure you have Xcode installed
2. Run: swiftc -o ShutdownTimer ShutdownTimer.swift -framework SwiftUI -framework AppKit
3. Run: ./create_dmg.sh to create distribution package

Or open in Xcode and build as a standard macOS app project.
EOF

# Create checksums
cd release/${RELEASE_NAME}
shasum -a 256 ShutdownTimer.dmg > checksums.txt
shasum -a 256 ShutdownTimer.app/Contents/MacOS/ShutdownTimer >> checksums.txt
cd ../..

# Create final zip
cd release
zip -r ../${RELEASE_NAME}.zip ${RELEASE_NAME}/
cd ..

echo "✅ Release package created: ${RELEASE_NAME}.zip"
echo "📦 Contents:"
echo "   - ShutdownTimer.app (ready to run)"
echo "   - ShutdownTimer-v1.0.dmg (installer)"
echo "   - Documentation (README, LICENSE, CHANGELOG)"
echo "   - Source code"
echo "   - Installation instructions"
echo "   - Checksums for verification"

ls -lh ${RELEASE_NAME}.zip
echo ""
echo "🚀 Ready for upload to SourceForge!"
echo ""
echo "Upload both:"
echo "   1. ${RELEASE_NAME}.zip (complete package)"
echo "   2. ShutdownTimer.dmg (direct download)"