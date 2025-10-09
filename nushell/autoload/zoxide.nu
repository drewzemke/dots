# depends on env setup in `config env`
# if not ('~/.zoxide.nu' | path exists) { zoxide init nushell | save -f ~/.zoxide.nu }
if not ('~/.zoxide.nu' | path exists) {
  print "missing ~/.zoxide.nu"
  exit 1 
}

source ~/.zoxide.nu
