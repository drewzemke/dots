# CAREFUL! Make sure you're editing this file '.dots', not in its usual folder

# path setup
fish_add_path -p /usr/local/sbin /usr/local/bin /usr/bin ~/.cargo/bin
{{#if dotter.packages.mac}}fish_add_path -p /opt/homebrew/bin{{/if}};

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

# helix abbreviations
abbr -a -- hx   {{editor}};

# git abbreviations
abbr -a -- g    'git'
abbr -a -- gs   'git status'
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

# jest abbreviations
abbr -a -- jw   'jest --watchAll --testPathPattern'

# zellij abbreviations
abbr -a -- zdev 'zellij action new-tab --layout dev'

# cargo abbreviations
abbr -a -- cb   'cargo build'
abbr -a -- cbr  'cargo build --release'
abbr -a -- ct   'cargo test'
abbr -a -- cr   'cargo run'

{{#if dotter.packages.work}}
source /Users/drewzee/.docker/init-fish.sh || true # Added by Docker Desktop
{{/if}};

{{#if dotter.packages.arch}}
source ~/.xprofile
{{/if}};
