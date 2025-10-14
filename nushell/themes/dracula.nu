# Dracula Theme for Nushell
# Based on https://draculatheme.com/contribute

# Dracula color palette
const dracula_background = "#282a36"
const dracula_current_line = "#44475a"
const dracula_foreground = "#f8f8f2"
const dracula_comment = "#6272a4"
const dracula_cyan = "#8be9fd"
const dracula_green = "#50fa7b"
const dracula_orange = "#ffb86c"
const dracula_pink = "#ff79c6"
const dracula_purple = "#bd93f9"
const dracula_red = "#ff5555"
const dracula_yellow = "#f1fa8c"

# Build the theme configuration
export def main [] {
  {
    # Primitive values
    binary: $dracula_cyan
    bool: $dracula_purple
    cellpath: $dracula_cyan
    date: $dracula_purple
    duration: $dracula_pink
    float: $dracula_orange
    int: $dracula_purple
    range: $dracula_pink
    filesize: $dracula_cyan
    string: $dracula_yellow
    nothing: $dracula_foreground

    # UI elements
    separator: $dracula_comment
    leading_trailing_space_bg: { bg: $dracula_red }
    header: { fg: $dracula_green attr: b }
    empty: $dracula_comment
    row_index: { fg: $dracula_green attr: b }
    hints: $dracula_comment
    search_result: { fg: $dracula_background bg: $dracula_yellow }

    # Shapes (syntax highlighting)
    shape_and: { fg: $dracula_purple attr: b }
    shape_binary: { fg: $dracula_purple attr: b }
    shape_block: { fg: $dracula_cyan attr: b }
    shape_bool: $dracula_purple
    shape_closure: { fg: $dracula_cyan attr: b }
    shape_custom: $dracula_green
    shape_datetime: { fg: $dracula_purple attr: b }
    shape_directory: $dracula_cyan
    shape_external: $dracula_cyan
    shape_external_resolved: { fg: $dracula_cyan attr: b }
    shape_externalarg: $dracula_green
    shape_filepath: $dracula_cyan
    shape_flag: { fg: $dracula_cyan attr: b }
    shape_float: { fg: $dracula_orange attr: b }
    shape_garbage: { fg: $dracula_red attr: b }
    shape_glob_interpolation: { fg: $dracula_cyan attr: b }
    shape_globpattern: { fg: $dracula_cyan attr: b }
    shape_int: { fg: $dracula_purple attr: b }
    shape_internalcall: { fg: $dracula_cyan attr: b }
    shape_keyword: { fg: $dracula_pink attr: b }
    shape_list: { fg: $dracula_cyan attr: b }
    shape_literal: $dracula_cyan
    shape_match_pattern: $dracula_green
    shape_matching_brackets: { attr: u }
    shape_nothing: $dracula_purple
    shape_operator: $dracula_pink
    shape_or: { fg: $dracula_purple attr: b }
    shape_pipe: { fg: $dracula_purple attr: b }
    shape_range: { fg: $dracula_pink attr: b }
    shape_record: { fg: $dracula_cyan attr: b }
    shape_redirection: { fg: $dracula_purple attr: b }
    shape_signature: { fg: $dracula_green attr: b }
    shape_string: $dracula_yellow
    shape_string_interpolation: { fg: $dracula_cyan attr: b }
    shape_table: { fg: $dracula_cyan attr: b }
    shape_vardecl: { fg: $dracula_cyan attr: u }
    shape_variable: $dracula_purple
  }
}

# Menu styling
export def menus [] {
  [
    {
      name: history_menu
      marker: "? "
      only_buffer_difference: false
      type: {
        layout: list
        page_size: 10
      }
      style: {
        text: $dracula_comment
        selected_text: {
          fg: $dracula_pink
          # bg: $dracula_current_line
          attr: b
        }
        description_text: $dracula_comment
      }
    }
    {
      name: completion_menu
      marker: "| "
      only_buffer_difference: false
      type: {
        layout: columnar
        columns: 4
        col_width: 20
        col_padding: 2
      }
      style: {
        text: $dracula_comment
        selected_text: {
          fg: $dracula_pink
          # bg: $dracula_purple
          attr: b
        }
        description_text: $dracula_comment
      }
    }
  ]
}
