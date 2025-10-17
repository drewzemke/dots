export def main [--rename (-r)] {
  cd ~/notes

  if $rename {
    zellij action rename-tab "notes"
  }

  # open editor to today's notes
  ^$env.EDITOR ./daily/(date now | format date "%Y-%m-%d").md

  cd -
}

