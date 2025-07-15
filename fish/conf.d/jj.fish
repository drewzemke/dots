# jj abbreviations
abbr -a -- js  'jj status'
abbr -a -- jl  'jj log'
abbr -a -- jd  'jj describe'
abbr -a -- jf  'jj git fetch'
abbr -a -- jP  'jj git push'
abbr -a -- je  'jj edit'
abbr -a -- jsq 'jj squash'
abbr -a -- jr  'jj rebase'
abbr -a -- jrs 'jj restore'
abbr -a -- J   'lazyjj'

# alt-j to run `jj log` while preserving the command line
bind alt-j 'jj log; commandline -f repaint'
