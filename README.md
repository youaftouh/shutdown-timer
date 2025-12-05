# Mac Shutdown Timer

A simple macOS desktop application that allows you to shutdown, restart, or log out of your Mac either immediately or after a specified delay.

## Features

- **Shutdown** - Power off your Mac
- **Restart** - Restart your Mac
- **Log Out** - Log out of your current session
- **Delayed Actions** - Set a timer (hours, minutes, seconds) before the action executes
- **Execute Now** - Perform any action immediately
- **Cancel Timer** - Cancel a scheduled action before it executes

## Building the App

### Option 1: Using Xcode (Recommended)

1. Open Xcode
2. Create a new macOS App project
3. Replace the default `ContentView.swift` with the contents of `ShutdownTimer.swift`
4. Copy the `Info.plist` to your project
5. Build and run (⌘R)

### Option 2: Using Swift from Terminal

```bash
# Compile the app
swiftc -o ShutdownTimer ShutdownTimer.swift -framework SwiftUI -framework AppKit

# Run it
./ShutdownTimer
```

## Permissions

The first time you run the app and try to execute an action, macOS will ask for permission to control System Events. This is required for the app to perform shutdown, restart, and logout operations.

Grant the permission in:
**System Settings → Privacy & Security → Automation**

## Usage

1. Select the action you want (Shutdown, Restart, or Log Out)
2. Either:
   - Set a timer by entering hours, minutes, and seconds, then click "Start Timer"
   - Click "Execute Now" to perform the action immediately
3. If a timer is running, you can cancel it at any time

## Technical Details

- Built with Swift and SwiftUI
- Uses AppleScript to execute system commands
- Requires macOS 13.0 or later
- Native macOS interface

## Safety Note

Be careful when using this app! Make sure to save your work before executing any actions, especially immediate ones.
