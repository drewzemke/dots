# depends on env setup in `config env`
if not ('~/.atuin.nu' | path exists) {
  print "missing ~/.atuin.nu"
  exit 1 
}

source ~/.atuin.nu
