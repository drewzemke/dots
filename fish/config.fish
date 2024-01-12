# CAREFUL! Make sure you're editing this file '.dots', not in its usual folder

# path setup
fish_add_path -p /usr/local/sbin /usr/local/bin /usr/bin ~/.cargo/bin ~/go/bin /usr/local/go/bin
# {{#if dotter.packages.mac}}
eval (/opt/homebrew/bin/brew shellenv)
# {{/if}}

# set env variable for XDG_CONFIG_HOME
set -gx XDG_CONFIG_HOME ~/.config/

# set editor and visual env variables
set -gx EDITOR {{editor}};
set -gx VISUAL {{editor}};

# set a theme for bat
set -gx BAT_THEME "Dracula";

# initialize zoxide
zoxide init fish | source

# file system abbreviations
alias      ls   'exa -1 --color=auto --icons --group-directories-first'
alias      lsa  'exa -1 --color=auto --icons --group-directories-first -la'
alias      lst  'exa -1 --color=auto --icons --group-directories-first -T --git-ignore'
abbr -a -- cat  'bat'
abbr -a -- rst  'source ~/.config/fish/config.fish'
abbr -a -- z..  'z -'

# helix abbreviations
abbr -a -- hx   {{editor}};

# git abbreviations
abbr -a -- g    'git'
abbr -a -- gs   'git status -s'
abbr -a -- gsv  'git status'
abbr -a -- gl   'git lg'
abbr -a -- ga   'git add'
abbr -a -- gad  'git add .'
abbr -a -- gc   'git commit'
abbr -a -- gcm  'git commit -m'
abbr -a -- gca  'git commit --amend'
abbr -a -- gp   'git pull'
abbr -a -- gP   'git push'
abbr -a -- gri  'git rebase --interactive'
abbr -a -- grc  'git rebase --continue'
abbr -a -- gra  'git rebase --abort'
abbr -a -- gco  'git checkout'
abbr -a -- g..  'git checkout -'
abbr -a -- gn   'git new'

# jest abbreviations
abbr -a -- jw   'pnpm jest --watchAll --testPathPattern'

# zellij abbreviations
abbr -a -- zdev 'zellij action new-tab --layout dev'

# cargo abbreviations
abbr -a -- cb   'cargo build'
abbr -a -- cbr  'cargo build --release'
abbr -a -- ct   'cargo test'
abbr -a -- cr   'cargo run'

# training my self to use `rip` instead of `rm`
abbr -a -- rm   '"Nope, use `rip` instead."'

# enable starting zellij with a keyboard shortcut.
# loads a previous session if one is available,
# otherwise just starts a new session
# (only works outside of zellij, fortunately)
bind \cz 'zellij a || zellij; commandline -f repaint'

# {{#if dotter.packages.work}}
source /Users/drewzee/.docker/init-fish.sh || true # Added by Docker Desktop

# initiate fnm (used to manage node installs)
fnm env | source

# set url for the `borat` cli
set -gx BORAT_URL "http://172.16.4.100";
# {{/if}}

# {{#if dotter.packages.arch}}
source ~/.xprofile
# {{/if}}
