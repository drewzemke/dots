# start kanata and atuin daemon if not already running

export def main [] {
  # kanata
  if (do { pgrep -x kanata } | complete).exit_code != 0 {
    job spawn { sudo kanata --cfg ~/.config/kanata/config.kbd }
    print "kanata started"
  }

  # atuin daemon
  if (do { pgrep -f "atuin daemon" } | complete).exit_code != 0 {
    $env.XDG_RUNTIME_DIR = $"($env.HOME)/.local/run"
    job spawn { atuin daemon }
    print "atuin daemon started"
  }
}
