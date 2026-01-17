# toggle between .spec.{ext} and .{ext} filenames
export def main [input?: string]: [string -> string, nothing -> string] {
  let filename = $input | default $in

  if ($filename | str contains '.spec.') {
    # remove .spec from the filename
    $filename | str replace '.spec.' '.'
  } else {
    # add .spec before the extension
    $filename | str replace --regex '\.([^.]*)$' '.spec.$1'
  }
}
