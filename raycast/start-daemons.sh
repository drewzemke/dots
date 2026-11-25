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
        keystroke "bash -c 'sudo pkill -x kanata 2>/dev/null; nohup sudo $HOME/.cargo/bin/kanata --cfg $HOME/.config/kanata/config.kbd >/dev/null 2>&1 & disown; pkill -x army 2>/dev/null; nohup $HOME/.nix-profile/bin/army run </dev/null >/dev/null 2>&1 & disown; exit'"
        key code 36
    end tell
end tell
EOF
