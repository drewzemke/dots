# CAREFUL! Make sure you're editing this file '.dots', not in its usual folder
#
# TODO: split this config into `/conf.d/git.fish` `/conf.d/exa.fish`, etc

# path setup
fish_add_path -p /usr/local/sbin /usr/local/bin /usr/bin ~/.cargo/bin ~/.deno/bin /usr/local/go/bin

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

# bindings for navigating word-by-word
bind \eh backward-word
bind \el forward-word

# put openai and anthropic API keys into env
set -gx OPENAI_API_TOKEN (cat ~/.openai)
set -gx ANTHROPIC_API_TOKEN (cat ~/.anthropic)
  
# docker-related abbreviations
abbr -a -- dcu  'docker compose up -d'
abbr -a -- dcd  'docker compose down' 
abbr -a -- dcp  'docker compose pull' 
abbr -a -- D    'lazydocker' 

# atuin
atuin init fish --disable-up-arrow | source

# {{#if dotter.packages.work}}
# ----------------------------
#  WORK STUFF
# ----------------------------
source /Users/drewzee/.docker/init-fish.sh || true # Added by Docker Desktop

# initiate fnm (used to manage node installs)
fnm env | source

# transfer gh and jira tokens from file to env
set -gx GITHUB_TOKEN (cat ~/.github_token)
set -gx JIRA_API_TOKEN (cat ~/.jira_token)
set -gx COPILOT_API_KEY (cat ~/.copilot)

# work kubernetes-related abbrevs
abbr -a -- kdev  'k9s --context=aws-dev'
abbr -a -- kqa   'k9s --context=aws-qa'
abbr -a -- kprod 'k9s --context=aws-prod'
# {{/if}}

# {{#if dotter.packages.linux}}
source ~/.xprofile
# {{/if}}
# 
