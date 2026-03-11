export def main [input: string] {
  let lines = $input | str trim | lines

  # find all of the bars that we need to align
  let bars: list<list<int>> = $lines
    | each {
        split chars
        | enumerate
        | where item == '|'
        | get index
    }

  # how many columns there are
  let cols = $bars | each { length } | math min | $in - 1

  # extract content of each "cell"
  let cells: list<list<string>> = $lines
    | zip $bars
    | each { |pair|
      let line = $pair.0
      let bars = $pair.1
      1..$cols | each { |col|
        let start = $bars | get ($col - 1) | $in + 1
        let end = $bars | get $col | $in - 1
        $line | str substring --grapheme-clusters  $start..$end | str trim
      }
    }
    
  # compute column widths (max cell length across all rows)
  let widths: list<int> = 0..($cols - 1) | each { |col|
      $cells
        | each { get $col | str length --grapheme-clusters }
        | math max
    }

  # format each line so that each cell has the correct min width
  $cells
    | each { |row|
        $row
        | enumerate
        | each { |it|
          let width = $widths | get $it.index
          if ($it.item | str trim | str starts-with "---") {
            # fill divider cells with hyphens
            "" | fill --width $width --character '-'
          } else {
            $it.item | fill --width $width
          }
        }
        | str join " | "
        | $"| ($in) |"
    }
    | append "" # to get a new line at the end
    | str join "\n"
}
