# jj workspace hooks for claude code worktree support

# create a jj workspace for claude (prints path to stdout)
export def create [] {
  let input = open --raw /dev/stdin | from json
  let name = $input.name
  let dir = $input.cwd | path join ".claude" "worktrees" $name

  mkdir ($dir | path dirname)
  jj workspace add $dir --name $name
  print $dir
}

# clean up a jj workspace
export def remove [] {
  let input = open --raw /dev/stdin | from json
  let worktree_path = $input.worktree_path
  let name = $worktree_path | path basename

  # forget from jj first, then remove the directory
  jj workspace forget $name
  rm -rf $worktree_path
}
