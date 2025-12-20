# Mac Shutdown Timer

A simple and elegant macOS desktop application that allows you to shutdown, restart, or log out of your Mac either immediately or after a specified delay.

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![Platform](https://img.shields.io/badge/platform-macOS%2013.0+-lightgrey.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

## Features

- **🔄 Multiple Actions** - Shutdown, restart, or log out your Mac
- **⏰ Delayed Execution** - Set custom timers with hours, minutes, and seconds
- **⚡ Immediate Actions** - Execute any action instantly
- **🔊 Sound Notifications** - Audio alert before action execution
- **❌ Cancel Anytime** - Stop scheduled actions before they execute
- **🎨 Native Interface** - Beautiful, modern macOS design
- **🔢 Smart Input** - Number-only validation for time fields
- **📱 Menu Bar** - Standard macOS menus with keyboard shortcuts

## Download

**[Download ShutdownTimer-v1.0.dmg](https://github.com/yourusername/shutdown-timer/releases/latest)**

## Installation

1. Download the DMG file
2. Open the DMG and drag "ShutdownTimer.app" to your Applications folder
3. Launch the app from Applications
4. Grant permission when prompted (required for system control)

## Permissions

The first time you use the app, macOS will request permission to control System Events. This is required for shutdown/restart/logout functionality.

**Grant permission in:** System Settings → Privacy & Security → Automation

## Usage

1. **Select Action**: Choose Shutdown, Restart, or Log Out
2. **Set Timer** (optional): Enter hours, minutes, and seconds
3. **Execute**:
   - Click "Start Timer" for delayed execution
   - Click "Execute Now" for immediate action
4. **Cancel**: Stop any running timer before it completes

## Screenshots

![Screenshot of ShutdownTimer App](https://github.com/youaftouh/shutdown-timer/blob/main/screenshots/Screenshot-app.png?raw=true)

![Screenshot of ShutdownTimer About](https://github.com/youaftouh/shutdown-timer/blob/main/screenshots/Screenshot-about.png?raw=true)

## System Requirements

- macOS 13.0 (Ventura) or later
- 64-bit Intel or Apple Silicon Mac

## Technical Details

- **Language**: Swift
- **Framework**: SwiftUI
- **Size**: ~1.2 MB
- **Architecture**: Universal (Intel + Apple Silicon)

## Safety Note

⚠️ **Important**: Save your work before using this app! The shutdown/restart actions will close all applications without additional warnings.

## Development

**Developer**: Yasser Ouaftouh  
**Tools**: Vibe coding using Kiro

### Building from Source

```bash
# Clone the repository
git clone https://github.com/yourusername/shutdown-timer.git
cd shutdown-timer

# Compile
swiftc -o ShutdownTimer ShutdownTimer.swift -framework SwiftUI -framework AppKit

# Create app bundle
./create_dmg.sh
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history.

## Support

If you encounter any issues or have suggestions, please create an issue on the project repository.

---

*Built with ❤️ using Kiro IDE*
