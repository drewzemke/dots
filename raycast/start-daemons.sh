#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Start Daemons
# @raycast.mode silent

# Optional parameters:
# @raycast.packageName System

wezterm cli spawn --new-window
sleep 1
osascript <<'EOF'
tell application "System Events"
    tell process "WezTerm"
        keystroke "bash -c '/Users/drewzee/.cargo/bin/atuin daemon start & disown; sudo pkill kanata 2>/dev/null; sudo /Users/drewzee/.cargo/bin/kanata --cfg /Users/drewzee/.config/kanata/config.kbd & disown && exit'"
        key code 36
    end tell
end tell
EOF
