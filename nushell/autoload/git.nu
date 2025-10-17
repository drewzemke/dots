# abbreviations
use ../modules/abbrevs.nu *

add-abbrev g    'git'
add-abbrev gs   'git status -s'
add-abbrev gsv  'git status'
add-abbrev gl   'git lg'
add-abbrev ga   'git add'
add-abbrev gad  'git add .'
add-abbrev gc   'git commit'
add-abbrev gcm  'git commit -m'
add-abbrev gca  'git commit --amend'
add-abbrev gp   'git pull'
add-abbrev gP   'git push'
add-abbrev gri  'git rebase --interactive'
add-abbrev grc  'git rebase --continue'
add-abbrev gra  'git rebase --abort'
add-abbrev gco  'git checkout'
add-abbrev g..  'git checkout -'
add-abbrev gsm  'git stash -um'
add-abbrev gsl  'git stash list'
add-abbrev gsp  'git stash pop'
add-abbrev gsd  'git stash drop'
add-abbrev gb   'git bisect'
add-abbrev gn   'git lg origin/(git branch --show-current)..head'
add-abbrev gi   'git lg head..origin/(git branch --show-current)'
add-abbrev gsu  'git submodule update --init --recursive'
add-abbrev prc  'gh pr create -B'
add-abbrev prv  'gh pr view -w'
add-abbrev pry  'gh pr view --json url --jq .url | pbcopy'
add-abbrev G    'gitui'

# completions
use ../completions/git-completions.nu * 
