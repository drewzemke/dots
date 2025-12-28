#!/usr/bin/env nu
#
# install kanata LaunchDaemon with home directory substitution

def main [] {
  let src = $env.FILE_PWD | path join "LaunchDaemons/com.local.kanata.plist"
  let dest = "/Library/LaunchDaemons/com.local.kanata.plist"

  let content = open $src | str replace --all "{{home}}" $env.HOME

  print "Installing kanata daemon..."
  $content | sudo tee $dest | ignore
  sudo chown root:wheel $dest
  sudo chmod 644 $dest
  sudo launchctl bootstrap system $dest
  print "Done!"
}
