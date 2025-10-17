# depends on env setup in `config env`
if not ('~/.zoxide.nu' | path exists) {
  print "missing ~/.zoxide.nu"
  exit 1 
}

source ~/.zoxide.nu

# abbreviations
use ../modules/abbrevs.nu *

add-abbrev z.. 'z -'
