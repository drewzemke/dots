# fzf integration

# set FZF defaults
export-env {
    $env.FZF_DEFAULT_OPTS = '--height 40% --layout=reverse --border --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'
    $env.FZF_DEFAULT_COMMAND = $'($env.HOME)/.cargo/bin/rg --files --hidden --follow --no-ignore --ignore-file=($env.HOME)/.config/helix/ignore --ignore-file=./.ignore'
}

# common fzf wrapper: uses last word as query, replaces with selection
export def fzf-insert [
    --source: closure      # produces lines to pipe to fzf (omit to use fzf default)
    --preview: string      # fzf --preview command
    --transform: closure   # transform fzf output before inserting
] {
    let line = (commandline)
    let query = ($line | split row ' ' | last | default '')
    let prefix = ($line | str replace -r '\S*$' '')

    mut fzf_args = [--query $query]
    if ($preview | is-not-empty) { $fzf_args ++= [--preview $preview] }

    let raw = if ($source | describe) == 'nothing' {
        fzf ...$fzf_args | decode utf-8 | str trim
    } else {
        do $source | fzf ...$fzf_args | decode utf-8 | str trim
    }

    let r = if ($transform | describe) == 'nothing' { $raw } else { $raw | do $transform }
    if ($r | is-not-empty) { commandline edit --replace $"($prefix)($r)" }
}

# file picker (ctrl+t)
def fzf-file [] { fzf-insert }

export-env {
    $env.config.keybindings ++= [{
        name: fzf_file_widget
        modifier: control
        keycode: char_t
        mode: [emacs, vi_insert, vi_normal]
        event: { send: executehostcommand, cmd: fzf-file }
    }]
}
