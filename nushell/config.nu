# env vars 
$env.CARGO_HOME = $env.HOME | path join '.cargo'

$env.EDITOR = 'hx'
$env.VISUAL = $env.EDITOR

# path
use std/util "path add"
path add '/bin'
path add '/sbin'
path add '/usr/bin'
path add '/usr/sbin'
path add '/usr/local/bin'
path add '/usr/local/go/bin'
path add '/opt/homebrew/bin'
path add ($env.CARGO_HOME | path join 'bin')


$env.config.show_banner = false
$env.config.completions.algorithm = 'fuzzy'

def load_token [token_name, file_name] {
  let file_path = $env.HOME | path join $file_name
  $env | upsert $token_name (cat $file_path)
}

load_token OPEN_ROUTER_API_KEY .openrouter
load_token ANTHROPIC_API_KEY .anthropic

# TODO: any way to modularize the abbreviations?
let abbreviations = {
    dcu: 'docker compose up -d'
    dcd: 'docker compose down'
    G: 'gitui'
    J: 'jjui'
    p: 'pnpm'
    pint: 'pnpm test-integrated'
    jw: 'pnpm jest --watchAll --testPathPattern'
    jf: 'jj fetch'
}

$env.config = {
    keybindings: [
      {
        name: abbr_menu
        modifier: none
        keycode: enter
        mode: [emacs, vi_normal, vi_insert]
        event: [
            { send: menu name: abbr_menu }
            { send: enter }
        ]
      }
      {
        name: abbr_menu
        modifier: none
        keycode: space
        mode: [emacs, vi_normal, vi_insert]
        event: [
            { send: menu name: abbr_menu }
            { edit: insertchar value: ' '}
        ]
      }
    ]

    menus: [
        {
            name: abbr_menu
            only_buffer_difference: false
            marker: none
            type: {
                layout: columnar
                columns: 1
                col_width: 20
                col_padding: 2
            }
            style: {
                text: green
                selected_text: green_reverse
                description_text: yellow
            }
            source: { |buffer, position|
              # Find the last command separator position
              let last_sep_pos = [';' '|' '(' '{']
                | each { |c| $buffer | str index-of --end $c }
                | math max

              let is_whole = ($last_sep_pos == -1)
              let prefix = if $is_whole { "" } else { $buffer | str substring 0..$last_sep_pos }
              let last_part = if $is_whole { $buffer } else { $buffer | str substring ($last_sep_pos + 1).. }

              let current_cmd = ($last_part | str trim | split row ' ' | first)
              let match = ($abbreviations | get -o $current_cmd)

              if ($match | is-empty) {
                {value: $buffer}
              } else {
                {value: ($prefix + ($last_part | str replace $current_cmd $match))}
              }
          }
       }
    ]
}

