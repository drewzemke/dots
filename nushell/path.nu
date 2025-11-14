use std/util "path add"

path add '/bin'
path add '/sbin'
path add '/usr/bin'
path add '/usr/sbin'
path add '/usr/local/bin'
path add '/usr/local/go/bin'
path add '/opt/homebrew/bin'
path add '/opt/homebrew/bin'
path add ($env.BUN_INSTALL | path join 'bin')
path add ($env.CARGO_HOME | path join 'bin')
