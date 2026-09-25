# shared helpers for the jj workflow scripts

# run a jj/gh command with consistent error handling and output
export def run-jj [command: closure, description: string, no_out: bool = false] {
  let output = (do $command | complete)
  if $output.exit_code != 0 {
    print $"(ansi red)Error:(ansi reset) ($description) failed with exit code ($output.exit_code)"
    print -n $output.stderr
    false
  } else {
    if not $no_out {
      print -n $output.stdout
    }
    true
  }
}

# get the default branch name for the current repo
export def get-default-branch [] {
  jj log -r "trunk()" --no-graph -T 'remote_bookmarks.filter(|b| (b.name() == "main" || b.name() == "master" || b.name() == "trunk") && (b.remote() == "origin" || b.remote() == "upstream")).map(|b| b.name()).join("")' | str trim
}

# print a colored step header
export def print-step [message: string] {
  print $"(ansi magenta)→(ansi reset) ($message)"
}
