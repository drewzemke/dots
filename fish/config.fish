# CAREFUL: Make sure you're editing this file '.dots', not in its usual folder

# path setup
if not contains -- /usr/local/sbin $PATH
    set --export BUN_INSTALL "$HOME/.bun"
    fish_add_path -p /usr/local/sbin /usr/local/bin /usr/bin ~/.cargo/bin ~/.deno/bin /usr/local/go/bin $BUN_INSTALL/bin
end

# {{#if dotter.packages.mac}}
if test -f /opt/homebrew/bin/brew
    eval (/opt/homebrew/bin/brew shellenv &)
end
# {{/if}}

# set env variable for XDG_CONFIG_HOME
if not set -q XDG_CONFIG_HOME
    set -gx XDG_CONFIG_HOME ~/.config/
end

# set editor and visual env variables
if not set -q EDITOR
    set -gx EDITOR {{editor}}
    set -gx VISUAL {{editor}}
end

if status is-interactive
    # app abbreviations
    abbr -a -- hx   {{editor}}
    abbr -a -- G    'gitui'
    abbr -a -- rm   '"Nope, use `rip` instead."'
    alias claude="$HOME/.claude/local/claude"
end

# put API keys into env 
load_token OPENAI_API_TOKEN ~/.openai &
load_token OPENAI_API_KEY ~/.openai &
load_token ANTHROPIC_API_TOKEN ~/.anthropic &
load_token ANTHROPIC_API_KEY ~/.anthropic &
load_token OPENROUTER_API_KEY ~/.openrouter &

# atuin
atuin init fish --disable-up-arrow | source &

# {{#if dotter.packages.work}}
# ----------------------------
#  WORK STUFF
# ----------------------------
# initiate fnm (used to manage node installs)
# if not set -q FNM_DIR; and type -q fnm
#     fnm env | source &
# end

# set env variables for AWS
if not set -q AWS_PROFILE
    set -gx AWS_PROFILE dev
end

# put API keys into env 
load_token GITHUB_TOKEN ~/.github_token &
load_token JIRA_API_TOKEN ~/.jira_token &
load_token COPILOT_API_KEY ~/.copilot &

if status is-interactive
    abbr -a -- kdev  'k9s --context=aws-dev'
    abbr -a -- kqa   'k9s --context=aws-qa'
    abbr -a -- kprod 'k9s --context=aws-prod'
end
# {{/if}}

# {{#if dotter.packages.linux}}
if test -f ~/.xprofile
    source ~/.xprofile
end
# {{/if}}
