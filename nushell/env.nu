# zoxide setup
if not ('~/.zoxide.nu' | path exists) {
  zoxide init nushell | save -f ~/.zoxide.nu
}

# atuin setup: autoload/atuin.nu sources ~/.local/share/atuin/init.nu, which
# atuin generates at install time. it goes stale after a nushell upgrade since
# it targets the old nu syntax; regenerate with:
#   atuin init nu | save -f ~/.local/share/atuin/init.nu
