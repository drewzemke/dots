# CAREFUL! Make sure you're editing this file '.dots', not in its usual folder

# path setup
fish_add_path -p /usr/local/sbin /usr/local/bin /usr/bin ~/.cargo/bin

# set env variable for XDG_CONFIG_HOME
set -gx XDG_CONFIG_HOME ~/.config/

# set editor and visual env variables
set -gx EDITOR {{editor}};
set -gx VISUAL {{editor}};

# initialize zoxide
zoxide init fish | source

# file system abbreviations
abbr -a -- ls   'exa -1 --color=auto --icons --group-directories-first'
abbr -a -- lst  'exa -1 --color=auto --icons --group-directories-first -T --git-ignore'
abbr -a -- cat  bat
abbr -a -- rst  'source ~/.config/fish/config.fish'

# helix abbreviations
abbr -a -- hx {{editor}};

# git abbreviations
abbr -a -- gs   'git status'

# zellij abbreviations
abbr -a -- zdev 'zellij action new-tab --layout dev'
