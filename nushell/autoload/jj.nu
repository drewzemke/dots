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
  commit?: string@revsets  # the commit to push and create a PR for (defaults to @)
] {
   let revision = if ($commit | is-empty) { "@" } else { $commit }

   # push the commit
   let push_output = (jj push -c $revision --color=always | complete)

   if $push_output.exit_code != 0 {
     print $"Error: jj push failed with exit code ($push_output.exit_code)"
     print -n $push_output.stderr
     return
   }

   # get the branch name that was created for this commit
   let branch = (jj bookmark list -r $revision -T 'self.name()' | str trim)

   # create PR with the branch
   let pr_output = (gh pr create -B main --head $branch --fill | complete)

   if $pr_output.exit_code != 0 {
     print $"Error: gh pr create failed with exit code ($pr_output.exit_code)"
     print -n $pr_output.stderr
     return
   }

   # get the PR URL and copy to clipboard
   let pr_url = (gh pr view --json url --jq .url)
   $pr_url | pbcopy

   print $"✓ Created PR: ($pr_url)"
   print "✓ URL copied to clipboard"
}

# removes the import from global scope
hide revsets
