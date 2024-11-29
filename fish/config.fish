# CAREFUL: Make sure you're editing this file '.dots', not in its usual folder

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

# app abbreviations
abbr -a -- hx   {{editor}};
abbr -a -- G    'gitui'
abbr -a -- rm   '"Nope, use `rip` instead."'

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

# atuin
atuin init fish --disable-up-arrow | source

# {{#if dotter.packages.work}}
# ----------------------------
#  WORK STUFF
# ----------------------------
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
