# put a message in the top corner of the zjstatus bar
export def main [input?: string] {
  let msg = $input | default --empty $in

  if ($msg | is-not-empty) {
    zellij pipe zjstatus::pipe::pipe_corner::($msg)
  }
}
