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
abbr -a -- gsm  'git stash -m'
abbr -a -- gsl  'git stash list'
abbr -a -- gsp  'git stash pop'
abbr -a -- gsd  'git stash drop'
abbr -a -- gn   'git lg origin/(git branch --show-current)..head'
abbr -a -- gi   'git lg head..origin/(git branch --show-current)'
abbr -a -- gsu  'git submodule update --init --recursive'
abbr -a -- prc  'gh pr create -B'
abbr -a -- prv  'gh pr view -w'

# zellij abbreviations
abbr -a -- zdev 'zellij action new-tab --layout dev'

# gitui abbreviations
abbr -a -- G    'gitui'

# cargo abbreviations
abbr -a -- cb   'cargo build'
abbr -a -- cbr  'cargo build --release'
abbr -a -- ct   'cargo test'
abbr -a -- cr   'cargo run'

# run nix-shell using fish
abbr -a -- ns   'nix-shell --run fish'

# training my self to use `rip` instead of `rm`
abbr -a -- rm   '"Nope, use `rip` instead."'

# using an abbreviation for my own app, is that weird?
abbr -a -- tod  'todoist-tui'

# enable starting zellij with a keyboard shortcut.
# loads a previous session if one is available,
# otherwise just starts a new session
# (only works outside of zellij, fortunately)
bind \cz 'zellij a || zellij; commandline -f repaint'

# put openai and anthropic API keys into env
export OPENAI_API_TOKEN=(cat ~/.openai)
export ANTHROPIC_API_TOKEN=(cat ~/.anthropic)
  
# {{#if dotter.packages.work}}
source /Users/drewzee/.docker/init-fish.sh || true # Added by Docker Desktop

# initiate fnm (used to manage node installs)
fnm env | source

# transfer gh and jira tokens from file to env
export GITHUB_TOKEN=(cat ~/.github_token)
export JIRA_API_TOKEN=(cat ~/.jira_token)

# docker-related abbreviations
abbr -a -- dcu  'docker compose up -d'
abbr -a -- dcd  'docker compose down' 
abbr -a -- dcp  'docker compose pull' 
abbr -a -- D    'lazydocker' 

# work kubernetes-related abbrevs
abbr -a -- kdev  'k9s --context=aws-dev'
abbr -a -- kqa   'k9s --context=aws-qa'
abbr -a -- kprod 'k9s --context=aws-prod'

# set up atuin (work only for now)
atuin init fish --disable-up-arrow | source
# {{/if}}

# {{#if dotter.packages.linux}}
source ~/.xprofile
# {{/if}}
