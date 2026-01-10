# macOS Launch Configuration

## LaunchAgents
Manual installation:

```bash
cp LaunchAgents/* ~/Library/LaunchAgents/
```

## LaunchDaemons
Manual installation (requires root). The plist uses `{{home}}` placeholders:

```bash
# substitute home dir and copy to system location
sed "s|{{home}}|$HOME|g" LaunchDaemons/com.local.kanata.plist | sudo tee /Library/LaunchDaemons/com.local.kanata.plist

# set permissions
sudo chown root:wheel /Library/LaunchDaemons/com.local.kanata.plist
sudo chmod 644 /Library/LaunchDaemons/com.local.kanata.plist

# load the daemon
sudo launchctl bootstrap system /Library/LaunchDaemons/com.local.kanata.plist
```
