import SwiftUI
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        setupMenu()
        
        let contentView = ContentView()
        
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 450),
            styleMask: [.titled, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        window.center()
        window.title = "Mac Shutdown Timer"
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    func setupMenu() {
        let mainMenu = NSMenu()
        
        // App Menu
        let appMenuItem = NSMenuItem()
        mainMenu.addItem(appMenuItem)
        let appMenu = NSMenu()
        appMenuItem.submenu = appMenu
        
        appMenu.addItem(NSMenuItem(title: "About Shutdown Timer", action: #selector(showAbout), keyEquivalent: ""))
        appMenu.addItem(NSMenuItem.separator())
        appMenu.addItem(NSMenuItem(title: "Quit Shutdown Timer", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        // Edit Menu
        let editMenuItem = NSMenuItem()
        mainMenu.addItem(editMenuItem)
        let editMenu = NSMenu(title: "Edit")
        editMenuItem.submenu = editMenu
        
        editMenu.addItem(NSMenuItem(title: "Cut", action: #selector(NSText.cut(_:)), keyEquivalent: "x"))
        editMenu.addItem(NSMenuItem(title: "Copy", action: #selector(NSText.copy(_:)), keyEquivalent: "c"))
        editMenu.addItem(NSMenuItem(title: "Paste", action: #selector(NSText.paste(_:)), keyEquivalent: "v"))
        editMenu.addItem(NSMenuItem(title: "Select All", action: #selector(NSText.selectAll(_:)), keyEquivalent: "a"))
        
        // Window Menu
        let windowMenuItem = NSMenuItem()
        mainMenu.addItem(windowMenuItem)
        let windowMenu = NSMenu(title: "Window")
        windowMenuItem.submenu = windowMenu
        
        windowMenu.addItem(NSMenuItem(title: "Minimize", action: #selector(NSWindow.miniaturize(_:)), keyEquivalent: "m"))
        windowMenu.addItem(NSMenuItem(title: "Zoom", action: #selector(NSWindow.zoom(_:)), keyEquivalent: ""))
        
        NSApplication.shared.mainMenu = mainMenu
    }
    
    @objc func showAbout() {
        let alert = NSAlert()
        alert.messageText = "Shutdown Timer"
        alert.informativeText = "Version 1.0\n\nDeveloper: Yasser Ouaftouh\nTools: Vibe coding using Kiro\n\nA simple Mac app to schedule shutdowns, restarts, and logouts."
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()

struct ContentView: View {
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    @State private var seconds: Int = 0
    @State private var isTimerActive = false
    @State private var remainingTime: TimeInterval = 0
    @State private var timer: Timer?
    @State private var selectedAction: ShutdownAction = .shutdown
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    enum ShutdownAction: String, CaseIterable {
        case shutdown = "Shutdown"
        case restart = "Restart"
        case logout = "Log Out"
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 20) {
                // Logo
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.blue, Color.purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 80, height: 80)
                        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                    
                    Image(systemName: "power")
                        .font(.system(size: 40, weight: .semibold))
                        .foregroundColor(.white)
                }
                .padding(.top, 10)
                
                Text("Mac Shutdown Timer")
                    .font(.title2)
                    .fontWeight(.bold)
                
                // Action Picker
                Picker("Action", selection: $selectedAction) {
                ForEach(ShutdownAction.allCases, id: \.self) { action in
                    Text(action.rawValue).tag(action)
                }
            }
            .pickerStyle(.segmented)
            .disabled(isTimerActive)
            
            if !isTimerActive {
                // Time Input
                HStack(spacing: 15) {
                    TimeInputField(value: $hours, label: "Hours", range: 0...23)
                    TimeInputField(value: $minutes, label: "Minutes", range: 0...59)
                    TimeInputField(value: $seconds, label: "Seconds", range: 0...59)
                }
                
                // Action Buttons
                HStack(spacing: 15) {
                    Button("Start Timer") {
                        startTimer()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(hours == 0 && minutes == 0 && seconds == 0)
                    
                    Button("Execute Now") {
                        executeAction()
                    }
                    .buttonStyle(.bordered)
                }
            } else {
                // Timer Display
                VStack(spacing: 10) {
                    Text("Time Remaining")
                        .font(.headline)
                    
                    Text(formatTime(remainingTime))
                        .font(.system(size: 48, weight: .bold, design: .monospaced))
                    
                    Text("Action: \(selectedAction.rawValue)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Button("Cancel") {
                        cancelTimer()
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                }
            }
            }
            .padding(30)
            .frame(width: 400)
            
            // Powered by Kiro credit
            Text("Powered by Kiro")
                .font(.caption2)
                .foregroundColor(.secondary)
                .padding([.bottom, .trailing], 8)
        }
        .alert("Shutdown Timer", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    func startTimer() {
        let totalSeconds = TimeInterval(hours * 3600 + minutes * 60 + seconds)
        remainingTime = totalSeconds
        isTimerActive = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if remainingTime > 0 {
                remainingTime -= 1
            } else {
                executeAction()
                cancelTimer()
            }
        }
    }
    
    func cancelTimer() {
        timer?.invalidate()
        timer = nil
        isTimerActive = false
        remainingTime = 0
    }
    
    func executeAction() {
        // Play sound notification
        NSSound.beep()
        
        let script: String
        
        switch selectedAction {
        case .shutdown:
            script = "tell application \"System Events\" to shut down"
        case .restart:
            script = "tell application \"System Events\" to restart"
        case .logout:
            script = "tell application \"System Events\" to log out"
        }
        
        if let appleScript = NSAppleScript(source: script) {
            var error: NSDictionary?
            appleScript.executeAndReturnError(&error)
            
            if let error = error {
                alertMessage = "Error: \(error["NSAppleScriptErrorMessage"] ?? "Unknown error")"
                showAlert = true
            }
        }
    }
    
    func formatTime(_ time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

struct TimeInputField: View {
    @Binding var value: Int
    let label: String
    let range: ClosedRange<Int>
    @State private var textValue: String = ""
    
    var body: some View {
        VStack(spacing: 5) {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
            
            TextField("0", text: $textValue)
                .textFieldStyle(.roundedBorder)
                .multilineTextAlignment(.center)
                .frame(width: 80)
                .onAppear {
                    textValue = value == 0 ? "" : "\(value)"
                }
                .onChange(of: textValue) { oldValue, newValue in
                    // Filter to only allow digits
                    let filtered = newValue.filter { $0.isNumber }
                    if filtered != newValue {
                        textValue = filtered
                    }
                    
                    // Update the bound value
                    if let intValue = Int(filtered) {
                        if intValue >= range.lowerBound && intValue <= range.upperBound {
                            value = intValue
                        } else if intValue > range.upperBound {
                            value = range.upperBound
                            textValue = "\(range.upperBound)"
                        }
                    } else {
                        value = 0
                    }
                }
                .onChange(of: value) { oldValue, newValue in
                    if newValue == 0 && textValue != "" {
                        textValue = ""
                    }
                }
        }
    }
}


