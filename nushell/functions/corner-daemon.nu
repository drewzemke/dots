# background daemon that periodically updates the zjstatus corner
#
# spawns a detached sh process that loops, calling media-notify and
# github-notify on independent intervals. one instance per zellij session.

const PID_DIR = "/tmp/zjstatus-daemons"

def pid-file [] {
  let session = $env.ZELLIJ_SESSION_NAME? | default "default"
  $"($PID_DIR)/($session).pid"
}

def already-running [] {
  let pf = pid-file
  if not ($pf | path exists) { return false }
  let pid = try { open $pf | str trim } catch { return false }
  (do { ^kill -0 ($pid | into int) } | complete).exit_code == 0
}

# start the daemon if not already running for this session
export def ensure [] {
  if (already-running) { return }

  let loop = $"($env.HOME)/dots/macos/scripts/corner-loop.sh"
  let media_mod = $"($env.HOME)/dots/nushell/functions/media-notify.nu"
  let gh_mod = $"($env.HOME)/dots/nushell/functions/github-notify.nu"
  let pf = pid-file

  sh -c $"'($loop)' '($pf)' '($media_mod)' '($gh_mod)' >/dev/null 2>&1 &"
}

# stop the daemon for this session
export def stop [] {
  let pf = pid-file
  if ($pf | path exists) {
    let pid = try { open $pf | str trim | into int } catch { return }
    try { kill $pid }
    rm -f $pf
  }
}
