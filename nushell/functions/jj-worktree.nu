# jj workspace hooks for claude code worktree support

# create a jj workspace for claude (prints path to stdout)
export def create [] {
  let input = open --raw /dev/stdin | from json
  let name = $input.name
  let repo = $input.cwd | path basename
  let dir = $"/tmp/jj-worktrees/($repo)/($name)"

  jj workspace add $dir --name $name
  print $dir
}

# clean up a jj workspace
export def remove [] {
  let input = open --raw /dev/stdin | from json
  let worktree_path = $input.worktree_path
  let name = $worktree_path | path basename

  # forget from jj (run from original repo), then remove the directory
  cd $input.cwd
  jj workspace forget $name
  rm -rf $worktree_path
}
