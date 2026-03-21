#!/usr/bin/swift

// Required parameters:
// @raycast.schemaVersion 1
// @raycast.title Fix WezTerm Window
// @raycast.mode silent

// Optional parameters:
// @raycast.packageName Window Management

import Cocoa

// get the visible frame of the main screen (excludes dock + menu bar)
guard let screen = NSScreen.main else { exit(1) }
let visible = screen.visibleFrame

// find wezterm and resize its window
let wezterms = NSRunningApplication.runningApplications(withBundleIdentifier: "com.github.wez.wezterm")
guard let wez = wezterms.first else {
    fputs("WezTerm not running\n", stderr)
    exit(1)
}

wez.activate()
usleep(100_000)

// use CGWindow API to find and resize
let script = """
tell application "System Events"
    tell process "WezTerm"
        set position of window 1 to {100, 100}
        set size of window 1 to {800, 600}
        delay 0.3
        set position of window 1 to {\(Int(visible.origin.x)), \(Int(screen.frame.height - visible.origin.y - visible.height))}
        set size of window 1 to {\(Int(visible.width)), \(Int(visible.height))}
    end tell
end tell
"""

let proc = Process()
proc.executableURL = URL(fileURLWithPath: "/usr/bin/osascript")
proc.arguments = ["-e", script]
try proc.run()
proc.waitUntilExit()
