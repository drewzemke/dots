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

# push a JJ commit and create a PR
export def jpr [
  commit?: string@revsets               # the commit to push and create a PR for (defaults to @)
  --target(-t): string@local-bookmarks  # target branch for the PR (defaults to repo's default branch)
] {
   let revision = if ($commit | is-empty) { "@" } else { $commit }

   # get the target branch (use provided or detect default)
   let target_branch = if ($target | is-empty) {
     gh repo view --json defaultBranchRef --jq .defaultBranchRef.name | str trim
   } else {
     $target
   }

   # get the commit ID before pushing (so we can look up the create bookmark later)
   let commit_id = (jj log -r $revision -T 'self.commit_id().short()' --no-graph | str trim)

   # push the commit
   let push_output = (jj push -c $revision --color=always | complete)

   if $push_output.exit_code != 0 {
     print $"(ansi red)Error:(ansi reset) jj push failed with exit code ($push_output.exit_code)"
     print -n $push_output.stderr
     return
   }

   # get the branch name that was created for this commit
   let branch = (jj bookmark list -r $commit_id -T 'self.name()' | str trim)
   print $"(ansi green)✓(ansi reset) Pushed branch: (ansi cyan)($branch)(ansi reset)"


   # create PR with the branch
   let pr_output = (gh pr create -B $target_branch --head $branch --fill-verbose | complete)

   if $pr_output.exit_code != 0 {
     print $"(ansi red)Error:(ansi reset) gh pr create failed with exit code ($pr_output.exit_code)"
     print -n $pr_output.stderr
     return
   }


   # get the PR URL and title, copy URL to clipboard
   let pr_info = (gh pr view $branch --json url,title | from json)
   $pr_info.url | pbcopy

   print $"(ansi green)✓(ansi reset) Created PR: (ansi yellow)($pr_info.title)(ansi reset)"
   print $"    (ansi blue)($pr_info.url)(ansi reset)"
   print $"(ansi green)✓(ansi reset) URL copied to clipboard"
}

# removes the import from global scope
hide revsets
hide local-bookmarks
