# clipboard keybindings

const clipboard_cmd = if $nu.os-info.name == 'macos' { 'pbcopy' } else { 'xclip -selection clipboard' }

# ctrl+y to yank command line to system clipboard
$env.config.keybindings ++= [{
    name: yank_to_clipboard
    modifier: control
    keycode: char_y
    mode: [emacs, vi_insert, vi_normal]
    event: {
        send: executehostcommand
        cmd: $"commandline | ($clipboard_cmd)"
    }
}]
