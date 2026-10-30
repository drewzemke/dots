# macOS Launch Configuration

## LaunchAgents
Manual installation:

```bash
cp LaunchAgents/* ~/Library/LaunchAgents/
```

## LaunchDaemons
Manual installation (requires root). kanata needs the karabiner vhid daemon running first. The kanata plist uses `{{home}}` placeholders:

```bash
# substitute home dir and copy to system location
sed "s|{{home}}|$HOME|g" LaunchDaemons/com.local.kanata.plist | sudo tee /Library/LaunchDaemons/com.local.kanata.plist

# set permissions
sudo chown root:wheel /Library/LaunchDaemons/com.local.kanata.plist
sudo chmod 644 /Library/LaunchDaemons/com.local.kanata.plist

# load the daemon
sudo launchctl bootstrap system /Library/LaunchDaemons/com.local.kanata.plist

# same for the karabiner vhid daemon (no placeholders)
sudo cp LaunchDaemons/com.local.karabiner-vhid-daemon.plist /Library/LaunchDaemons/
sudo chown root:wheel /Library/LaunchDaemons/com.local.karabiner-vhid-daemon.plist
sudo chmod 644 /Library/LaunchDaemons/com.local.karabiner-vhid-daemon.plist
sudo launchctl bootstrap system /Library/LaunchDaemons/com.local.karabiner-vhid-daemon.plist
```
