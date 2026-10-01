status is-interactive; or return

set -l base --icons --group-directories-first
alias ls "eza $base"
alias ll "eza $base -l --git --time-style=relative --header"
alias lsa "eza $base -la --git --time-style=relative --header"
alias lst "eza $base -T --git-ignore --level=2"
