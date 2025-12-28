# macOS Launch Configuration

## LaunchAgents
Auto-deployed by dotter to `~/Library/LaunchAgents/`

## LaunchDaemons
Stored here but need manual installation (require root):

```bash
# Install kanata daemon
sudo cp ~/dots/macos/LaunchDaemons/com.local.kanata.plist /Library/LaunchDaemons/
sudo chown root:wheel /Library/LaunchDaemons/com.local.kanata.plist
sudo chmod 644 /Library/LaunchDaemons/com.local.kanata.plist
sudo launchctl bootstrap system /Library/LaunchDaemons/com.local.kanata.plist
```
