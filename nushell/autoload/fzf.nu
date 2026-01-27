# fzf integration

# set FZF defaults 
$env.FZF_DEFAULT_OPTS = '--height 40% --layout=reverse --border --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'

$env.FZF_DEFAULT_COMMAND = $'($env.HOME)/.cargo/bin/rg --files --hidden --follow --no-ignore --ignore-file=($env.HOME)/.config/helix/ignore --ignore-file=./.ignore'

# ctrl+t to pick file with fzf and insert at cursor
$env.config.keybindings ++= [{
    name: fzf_file_widget
    modifier: control
    keycode: char_t
    mode: [emacs, vi_insert, vi_normal]
    event: {
        send: executehostcommand
        cmd: "let line = (commandline); let query = ($line | split row ' ' | last | default ''); let prefix = ($line | str replace -r '\\S*$' ''); let r = (fzf --query $query | decode utf-8 | str trim); if ($r | is-not-empty) { commandline edit --replace $\"($prefix)($r)\" }"
    }
}]
