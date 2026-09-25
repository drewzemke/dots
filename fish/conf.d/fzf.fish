set -gx FZF_DEFAULT_OPTS '--height 40% --layout=reverse --border --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'
set -gx FZF_DEFAULT_COMMAND "rg --files --hidden --follow --no-ignore --ignore-file=$HOME/.config/helix/ignore --ignore-file=./.ignore"

status is-interactive; or return

function __fzf_file
    __fzf_insert --preview 'bat --color=always --style=numbers --line-range=:500 {}'
end

function __fzf_dir
    set -l ignores --ignore-file ~/.config/helix/ignore
    test -f .ignore; and set -a ignores --ignore-file ./.ignore
    fd --type d --hidden --follow --no-ignore $ignores | __fzf_insert --preview 'eza --color=always {}'
end

bind ctrl-t __fzf_file
bind ctrl-alt-t __fzf_dir
