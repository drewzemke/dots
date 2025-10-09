# zoxide setup
if not ('~/.zoxide.nu' | path exists) {
  zoxide init nushell | save -f ~/.zoxide.nu
}

