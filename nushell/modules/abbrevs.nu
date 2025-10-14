# utils for adding abbrevs to the global dictionary and setting up
# the abbrev expansion mechanism
 
export def --env add-abbrev [abbrev: string, expansion: string] {
   $env.NUSHELL_ABBREVS = $env.NUSHELL_ABBREVS | upsert $abbrev $expansion
} 

export def --env setup-abbrevs [] {
  let abbreviations = $env.NUSHELL_ABBREVS

  # add keybindings for abbrev expansion
  $env.config.keybindings ++= [
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

  # add autocomplete based on abbreviations
  $env.config.menus ++= [
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
        # finds the last command separator position
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
