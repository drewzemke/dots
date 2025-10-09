# zoxide setup
if not ('~/.zoxide.nu' | path exists) {
  zoxide init nushell | save -f ~/.zoxide.nu
}

# atuin setup
if not ('~/.atuin.nu' | path exists) {
  atuin init nu | save -f ~/.atuin.nu
}
