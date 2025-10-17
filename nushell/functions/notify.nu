#!/usr/bin/env nu
#
# notify using zellij and zjstatus
export def main [input?: string] {
  let msg = $input | default --empty $in

  if ($msg | is-not-empty) {
    zellij pipe zjstatus::notify::($msg)
  }
}
