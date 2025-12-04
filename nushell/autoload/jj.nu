use ../modules/abbrevs.nu *

# jj-related abbreviations
add-abbrev jab 'jj abandon'
add-abbrev jb  'jj bookmark'
add-abbrev jc  'jj commit'
add-abbrev jd  'jj describe'
add-abbrev jdi 'jj diff'
add-abbrev je  'jj edit'
add-abbrev jev 'jj evolve'
add-abbrev jf  'jj fetch'
add-abbrev ji  'jj inc'
add-abbrev jl  'jj log'
add-abbrev jn  'jj new'
add-abbrev jo  'jj out'
add-abbrev jp  'jj prep'
add-abbrev jP  'jj push'
add-abbrev jpp 'jj prep; jj push'
add-abbrev jr  'jj rebase'
add-abbrev jrs 'jj restore'
add-abbrev js  'jj status'
add-abbrev jsh 'jj show'
add-abbrev jsp 'jj split'
add-abbrev jS  'jj squash'
add-abbrev ju  'jj undo'
add-abbrev J   'jjui'

# completions
use ../completions/jj-completions.nu *

# ============================================================================
# Helper Functions
# ============================================================================

# run a jj/gh command with consistent error handling and output
def run-jj [command: closure, description: string, no_out: bool = false] {
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

# get the default branch for the current repo
def get-default-branch [] {
  gh repo view --json defaultBranchRef --jq .defaultBranchRef.name | str trim
}

# print a colored step header
def print-step [message: string] {
  print $"(ansi magenta)→(ansi reset) ($message)"
}

# ============================================================================
# Commands
# ============================================================================

# push a JJ commit and create a PR
export def jpr [
  commit?: string@revsets               # the commit to push and create a PR for (defaults to @)
  --target(-t): string@local-bookmarks  # target branch for the PR (defaults to repo's default branch)
] {
   let revision = if ($commit | is-empty) { "@" } else { $commit }
   let target_branch = if ($target | is-empty) { get-default-branch } else { $target }

   # get the commit ID before pushing (so we can look it up after @ moves)
   let commit_id = (jj log -r $revision -T 'self.commit_id().short()' --no-graph | str trim)

   # push the commit
   if not (run-jj {jj push -c $revision --color=always} "jj push") { return }

   # get the branch name that was created for this commit
   let branch = (jj bookmark list -r $commit_id -T 'self.name()' | str trim)
   print $"(ansi green)✓(ansi reset) Pushed branch: (ansi cyan)($branch)(ansi reset)"

   # count commits between target and our revision
   let commit_count = (jj log -r $"ancestors\(($commit_id)\) & ~ancestors\(($target_branch)\)" --no-graph -T '"x"' | str length)

   # create PR with the branch
   let gh_args = if $commit_count > 1 {
     # multiple commits - prompt for title since gh would use branch name
     let title = (input "PR title: ")
     [-B $target_branch --head $branch --fill-verbose --title $title]
   } else {
     [-B $target_branch --head $branch --fill-verbose]
   }
   if not (run-jj {gh pr create ...$gh_args} "gh pr create" true) { return }

   # get the PR URL and title, copy URL to clipboard
   let pr_info = (gh pr view $branch --json url,title | from json)
   $pr_info.url | pbcopy

   print $"(ansi green)✓(ansi reset) Created PR: (ansi yellow)($pr_info.title)(ansi reset)"
   print $"    (ansi blue)($pr_info.url)(ansi reset)"
   print $"(ansi green)✓(ansi reset) URL copied to clipboard"
}

# rebase a branch onto a target commit
export def jrb [
  branch: string@local-bookmarks    # the branch to rebase
  target?: string@revsets            # the target commit to rebase onto (defaults to head of default branch)
  --push(-p)                         # push changes after rebasing
] {
   let target_commit = if ($target | is-empty) { get-default-branch } else { $target }

   print-step $"Duplicating commits from (ansi cyan)($branch)(ansi reset) onto (ansi cyan)($target_commit)(ansi reset)..."

   # duplicate all commits in the branch onto the target
   # using revset: all ancestors of branch that aren't ancestors of target
   if not (run-jj {jj duplicate -d $target_commit -r $"ancestors\(($branch)\) & ~ancestors\(($target_commit)\)" --color=always} "jj duplicate") { return }

   # extract the new head commit ID from the duplicate output
   # get the head of the newly duplicated commits (descendants of target that aren't reachable from the original branch)
   let new_head = (jj log -r $"heads\(descendants\(($target_commit)\) & ~ancestors\(($branch)\)\)" -n 1 --no-graph -T 'self.change_id().short()' | str trim)
   let new_head_shortest = (jj log -r $"heads\(descendants\(($target_commit)\) & ~ancestors\(($branch)\)\)" -n 1 --no-graph -T 'self.change_id().shortest()' | str trim)
   let new_head_rest = ($new_head | str substring ($new_head_shortest | str length)..)

   print $"(ansi green)✓(ansi reset) Duplicated commits from (ansi cyan)($branch)(ansi reset) onto (ansi cyan)($target_commit)(ansi reset)"
   print $"  New head: (ansi magenta)($new_head_shortest)(ansi dark_gray)($new_head_rest)(ansi reset)"

   if $push {
     # call jbp to move bookmark, push, and cleanup
     jbp $branch -d $new_head
   } else {
     print $"\n(ansi blue)ℹ(ansi reset) Bookmark (ansi cyan)($branch)(ansi reset) still points to old commits. Run (ansi yellow)jbp ($branch)(ansi reset) when ready to push."
   }
}

# push a branch (move bookmark, push, and cleanup old commits)
export def jbp [
  branch: string@local-bookmarks    # the branch to push
  --destination(-d): string@revsets # where to move the bookmark (defaults to @-)
] {
   let dest = if ($destination | is-empty) { "@-" } else { $destination }

   # capture the old commits at the bookmark location (for cleanup later)
   # get all ancestors of the current bookmark that aren't ancestors of the destination
   let old_commits = (jj log -r $"ancestors\(($branch)\) & ~ancestors\(($dest)\)" --no-graph -T 'self.change_id().short() ++ "\n"' | lines | str trim)

   print-step $"Moving bookmark (ansi cyan)($branch)(ansi reset) to (ansi yellow)($dest)(ansi reset)..."
   if not (run-jj {jj bookmark set $branch -r $dest --color=always --allow-backwards} "jj bookmark set") { return }

   print-step $"Pushing changes for (ansi cyan)($branch)(ansi reset)..."
   if not (run-jj {jj push -b $branch --color=always} "jj push") { return }

   print-step "Abandoning old commits..."
   if not (run-jj {jj abandon -r $"($old_commits | str join ' | ')" --color=always} "jj abandon") { return }

   print $"(ansi green)✓(ansi reset) Successfully pushed (ansi cyan)($branch)(ansi reset)"
}

# removes the import from global scope
hide revsets
hide local-bookmarks
